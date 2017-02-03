module Teki
  class DateMapper

    # weekly_schedule: Teki::WeeklySchedule
    def map(weekly_schedule)
    end

    def group_by_wday(time_instaces)
      result = {}
      time_instaces.each do |k, v|
        key = Teki::DateUtils.to_wday(k.wday)
        if result[key].nil?
          result[key] = {}
        end
        result[key][k] = v
      end
      result
    end

    def to_utc(time_instances)
      time_instances.map do |k, v|
        [k.getutc, v]
      end.to_h
    end

    # schedules: [Teki::Schedule]
    def to_time_instance(schedules)
      result = {}
      schedules.each do |schedule|
        Teki::DateUtils.iterate_time(schedule.time_range, Teki::DateUtils::HOUR) do |time|
          result[time] = if result[time].nil?
                           schedule.instance_count
                         else
                           result[time] + schedule.instance_count
                         end
        end
      end
      result
    end

  end
end
