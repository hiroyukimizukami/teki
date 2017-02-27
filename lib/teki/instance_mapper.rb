module Teki
  class InstanceMapper
    def map(weekly_schedule, instances)
    end

    def to_instance_based_schedule(weekly_schedule)
      result = {}
      weekly_schedule.keys.each do |day|
        schedule = to_instance_based_day_schedule(weekly_schedule.get(day))
        next if schedule.nil?

        schedule.each do |k, v|
          result[k] = {} if result[k].nil?
          result[k][day] = [] if result[k][day].nil?
          result[k][day] << v
          result[k][day].flatten!
        end
      end
      result
    end

    def to_instance_based_day_schedule(day_schedule)
      return if day_schedule.nil?
      result = {}
      day_schedule.map do |time, instances|
        instances.each do |instance|
          result[instance.instance_id] = [] unless result[instance.instance_id]
          result[instance.instance_id] << time.hour
        end
      end
      result
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
