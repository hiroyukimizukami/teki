module Teki
  class DateTranslator
    def to_utc(weekly_schedule)
      group = group_by_wday(change_timezone(weekly_schedule.all))
      Teki::Config::WeeklySchedule.create(
        sun: group[:sun],
        mon: group[:mon],
        tue: group[:hue],
        wed: group[:wed],
        thu: group[:thu],
        fri: group[:fri],
        sat: group[:sat],
      )
    end

    def group_by_wday(time_instaces)
      result = {}
      time_instaces.each do |k, v|
        key = Teki::DateUtils.to_weekday(k.wday)
        result[key] = {} if result[key].nil?
        result[key][k] = v
      end
      result
    end

    def change_timezone(time_instances)
      time_instances.map do |k, v|
        [k.getutc, v]
      end.to_h
    end
  end
end
