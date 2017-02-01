module Teki
  class DateUtils
    # weekly_schedule: Teki::WeeklySchedule
    def initialize(weekly_schedule)
      @weekly_schedule =  weekly_schedule.base_time
    end

    def to_utc
      # wday, hourをキーとして必要台数を対応付ける
      # wdayごとにグルーピング
      # 必要台数ごとにグルーピング
    end

    private

    def merge(box, schedule)

    end

    def to_wday(weekday)
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
