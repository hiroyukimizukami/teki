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
  end
end
