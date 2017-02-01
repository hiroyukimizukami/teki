require 'values'

module Teki
  module Aws
    class Layer < ::Value.new(:layer_name, :instances)
      def self.create(layer_name:, instances:)
        with(layer_name: layer_name, instances: instances)
      end
    end

    class Instance < ::Value.new(:instance_id, :availability_zone, :hostname, :instance_type, :auto_scaling_type)

      # Aws::OpsWorks::Types::DescribeInstancesResult
      def self.create(described_instance)
        with(instance_id: described_instance.instance_id,
             availability_zone: described_instance.availability_zone,
             hostname: described_instance.host_name,
             instance_type: described_instance.instance_type,
             auto_scaling_type: described_instance.auto_scaling_type)
      end
    end
  end
end
