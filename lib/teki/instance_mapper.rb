module Teki
  class InstanceMapper
    def map(weekly_schedule, instances)
    end

    def

    def to_instance_based_schedule(day_schedule)
      result = {}
      day_schedule.map do |time, instances|
        v.each do |instance|
          result[instance] = [] unless result[instance]
          result[instance] << time
        end
      end
    end

    def assign_instance(day_schedule, instances)
      day_schedule.map do |time, count|
        raise 'instance count shortage' if count > instances.count
        [time, instances[0...count]]
      end.to_h
    end

    def prioritize(instances)
      grouped = instances.group_by(&:availability_zone).sort.to_h
      grouped = grouped.map do |k, v|
        v.sort_by(&:hostname)
      end

      result = []
      count = grouped.count
      while grouped.flatten.count > 0 do
        (0...count).each do |i|
          next if grouped[i].empty?
          result << grouped[i].shift
        end
      end
      result
    end
  end
end
