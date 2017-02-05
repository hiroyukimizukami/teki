module Teki
  class DateUtils

    HOUR = 3600

    def self.step(range, step, &block)
      current = range.begin
      while current <= range.end
        block.call(current)
        current += step
      end
    end

    def self.to_wday(weekday)
      case weekday
      when 0 then
        :sun
      when 1 then
        :mon
      when 2 then
        :tue
      when 3 then
        :wed
      when 4 then
        :thu
      when 5 then
        :fri
      when 6 then
        :sat
      else
        raise 'Invalid weekday.'
      end
    end

    def self.to_instance_count_by_hour(schedules)
      result = {}
      schedules.each do |schedule|
        Teki::DateUtils.step(schedule[:time_range], Teki::DateUtils::HOUR) do |time|
          result[time] = result[time].nil? ? schedule[:count] : result[time] + schedule[:count]
        end
      end
      result
    end
  end
end
