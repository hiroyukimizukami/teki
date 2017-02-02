module Teki
  class DateMapper
    # schedules: [Teki::Schedule]
    def to_time_instance(base_time, schedules)
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
