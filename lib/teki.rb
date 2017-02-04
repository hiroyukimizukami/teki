require 'aws-sdk'
require './teki/aws/opsworks'
require './teki/aws/instance'

module Teki
end

key = ARGV[0]
secret = ARGV[1]
region = 'ap-northeast-1'

ops = Teki::Aws::OpsWorks.new(key: key, secret: secret, region: region)
p ops
layers = ops.layers('dev.plusc.jp')
p layers
