require 'values'

module Teki
  module Aws
    class Instance < ::Value.new(:instance_id, :availability_zone, :hostname, :instance_type, :auto_scaling_type)
      def self.create(described_instance)
        with(instance_id: described_instance.instance_id,
             availability_zone: described_instance.availability_zone,
             hostname: described_instance.hostname,
             instance_type: described_instance.instance_type,
             auto_scaling_type: described_instance.auto_scaling_type)
      end

      def timer?
        auto_scaling_type == 'timer'
      end
    end
  end
end
