require 'aws-sdk'
require './lib/teki/aws/opsworks'
require './lib/teki/aws/instance'

module Teki
  def self.execute(key:, secret:, region:, config_path:, dry_run: true)
    # config = Teki::Config.load(config_path)
    # layers = Teki::Aws::OpsWorks.new(key: key, secret: secret, region: region)
    # # TODO validate: instance_count, 24/7 present > Teki::Validator
    # config.layers.each do |layers|
    #   instances = layers[layers.layer_name]
    #   weekly_schedule_utc = Teki::DateTranslator.new.to_utc(layers.weekly_schedule)
    #   instaces_mapped = Teki::InstanceMapper.new.map(time_instances, instances)
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
