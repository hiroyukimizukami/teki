# region = ap-northeast-1
# credentialはopsworks::*が必要
require 'aws-sdk'
require 'aws-sdk-resources'
require 'aws_cf_signer'

key = ARGV[0]
secret = ARGV[1]
credentials = Aws::Credentials.new(key, secret)
client = Aws::OpsWorks::Client.new(region: 'ap-northeast-1', credentials: credentials)
stack = client.describe_stacks.stacks.map { |s| Aws::OpsWorks::Stack.new(s.stack_id, client: client) }.select { |s| s.name == 'dev.plusc.jp' }.first

layer_instances = {}
stack.layers.each do |layer|
  # stack_id, layer_id, one or more instance_idのどれかで指定するstack, layer両方指定するとエラーになる
  layer_instances[layer.shortname] = client.describe_instances(layer_id: layer.id).instances
end

layer_instances.each do |layer_name, instances|
  p layer_name
  instances.each do |instance|
    # auto_scaling_type = timer, load, nil(24/7)で返ってくる
    p "#{instance.hostname} - #{instance.auto_scaling_type} - #{instance.status}"
  end
end
