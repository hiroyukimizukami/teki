require 'aws-sdk'
require './lib/teki/aws/opsworks'
require './lib/teki/aws/instance'

module Teki
  def self.execute(key:, secret:, region:, config_path:, dry_run: true)
    # config = Teki::Config.load(config_path)
    # client = Teki::Aws::OpsWorks.new(key: key, secret: secret, region: region)
    # layers = client..layers(config.stack_name)
    # config.layers.each do |layer|
    # TODO filter time_based
    #   instances = layers[layer.name].select(&:timer?)
    #   weekly_schedule_utc = Teki::DateTranslator.new.to_utc(layer.weekly_schedule)
    # TODO validate instance count
    #   instaces_mapped = Teki::Aws::InstanceMapper.new.map(weekly_schedule_utc, instances)
    #   client.set_time_based_auto_scaling(instance_mapped)
    # end

    # puts instances_mapped
    # return if dry_run
  end
end

# key = ARGV[0]
# secret = ARGV[1]
# region = 'ap-northeast-1'

# ops = Teki::Aws::OpsWorks.new(key: key, secret: secret, region: region)
# p ops
# layers = ops.layers('dev.plusc.jp')
# p layers
