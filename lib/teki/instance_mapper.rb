module Teki
  class InstanceMapper
    def map(time_instances, instances:)
    end

    def group_by_ez(layers)
      layers.instances.group(&:availability_zone)
    end
  end
end
