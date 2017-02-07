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
        raise 'Invalid wday.'
      end
    end

    def self.to_wday(weekday)
      case weekday.to_sym
      when :sun then
        0
      when :mon then
        1
      when :tue then
        2
      when :wed then
        3
      when :thu then
        4
      when :fri then
        5
      when :sat then
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
