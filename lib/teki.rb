require 'aws-sdk'
require './lib/teki/aws/opsworks'
require './lib/teki/aws/instance'

module Teki
  def self.setup(key:, secret:, region:, config_path:, dry_run: true)
    config = Teki::Config.load(config_path)
    client = Teki::Aws::OpsWorks.new(key: key, secret: secret, region: region)
    layers = client.layers(config.stack_name)
    config.layers.each do |layer|
      raise "No such layer named: #{layer.name}" unless layers[layer.name]
      instances = layers[layer.name].select(&:timer?)
      weekly_schedule_utc = Teki::DateTranslator.new.to_utc(layer.weekly_schedule)
      instances_mapped = Teki::InstanceMapper.new.map(weekly_schedule_utc, instances)
      time_based_schedules = Teki::Aws::Formatter.format(instances_mapped)
      time_based_schedules.each do |time_based_schedule|
        puts time_based_schedule
        puts "skip: setting time based schedule" if dry_run
        client.set_time_based_auto_scaling(time_based_schedule) unless dry_run
      end
    end
  end
end
