module Teki
  class InstanceMapper
    def map(weekly_schedule, instances)
      weekly_schedule.all.map do |schedule|
      end
    end


    def assign_instance(day_schedule, instances)
      day_schedule.map do |time, count|

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
