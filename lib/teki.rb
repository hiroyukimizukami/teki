require "teki/version"

module Teki
  def self.setup(key:, secret:, region:, config_path:, dry_run: true)
    config = Teki::Config.load(config_path)
    client = Teki::Aws::OpsWorks.new(key: key, secret: secret, region: region)
    layers = client.layers(config.stack_name)
    config.layers.each do |layer|
      raise "No such layer named: #{layer.name}" unless layers[layer.name]

      instances = layers[layer.name].select(&:timer?)
      utc_schedule = Teki::DateTranslator.new.to_utc(layer.weekly_schedule)
      time_based_schedules = Teki::ScheduleMapper.new.assign_schedule_to_instance(instances, utc_schedule)
      Teki::Aws::Formatter.format(time_based_schedules).each do |time_based_schedule|
        client.set_time_based_auto_scaling(time_based_schedule) unless dry_run
      end
    end
  end
end
