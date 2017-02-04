module Teki
  class InstanceMapper
    # config: Teki::Config
    # layers: [Teki::Aws::Layer]
    def map(time_instances, layers:)
    end

    def group_by_ez(layers)
      layers.instances.group(&:availability_zone)
    end
  end
end
