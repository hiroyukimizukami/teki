module Teki
  class DateUtils

    HOUR = 3600

    def self.iterate_time(range, step, &block)
      current = range.begin
      while current <= range.end
        block.call(current)
        current += step
      end
    end

    def self.to_wday(weekday)
      case weekday
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
  end
end
