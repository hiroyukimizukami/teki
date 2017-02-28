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

    def self.to_weekday(wday)
      case wday
      when 0 then
        :sunday
      when 1 then
        :monday
      when 2 then
        :tuesday
      when 3 then
        :wednesday
      when 4 then
        :thursday
      when 5 then
        :friday
      when 6 then
        :saturday
      else
        raise 'Invalid wday.'
      end
    end

    def self.to_wday(weekday)
      case weekday.to_sym
      when :sunday then
        0
      when :monday then
        1
      when :tuesday then
        2
      when :wednesday then
        3
      when :thursday then
        4
      when :friday then
        5
      when :saturday then
        6
      else
        raise 'Invalid weekday.'
      end
    end

    # TODO move to config
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
