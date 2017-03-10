module Teki
  class InstanceMapper
    def map(weekly_schedule, instances)
    end

    def to_time_based_autoscaling_param(instance_setting)
      instance_setting.map do |instance_id, weekly_schedule|
        # TODO ::Teki::Aws::WeeklyScheduleに変換する
      end
    end

    def to_instance_based_schedule(weekly_schedule)
      result = {}

      weekly_schedule.to_h.each do |day, day_schedule|
        next if day_schedule.nil?
        schedule = to_instance_based_day_schedule(day_schedule)
        schedule.each do |instance_id, hours|
          result[instance_id] = {} if result[instance_id].nil?
          result[instance_id][day] = [] if result[instance_id][day].nil?
          result[instance_id][day] += hours
        end
      end
      result
    end

    def to_instance_based_day_schedule(day_schedule)
      return [] if day_schedule.nil?
      result = {}
      day_schedule.each do |time, instances|
        instances.each do |instance|
          result[instance.instance_id] = [] unless result[instance.instance_id]
          result[instance.instance_id] << time.hour
        end
      end
      result
    end

    def assign_instance(weekly_schedule, instances)
      prioritized = prioritize(instances)
      weekly_schedule.to_h.map do |wday, day_schedule|
        next [wday, nil] if day_schedule.nil?

        schedule = day_schedule.map do |time, count|
          raise 'instance count shortage' if count > prioritized.count
          [time, prioritized[0...count]]
        end.to_h
        [wday, schedule]
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
