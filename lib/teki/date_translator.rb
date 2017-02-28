module Teki
  class DateTranslator
    def to_utc(weekly_schedule)
      group = group_by_wday(change_timezone(weekly_schedule.all))
      Teki::Config::WeeklySchedule.create(
        sunday: group[:sunday],
        monday: group[:monday],
        tuesday: group[:tuesday],
        wednesday: group[:wednesday],
        thursday: group[:thursday],
        friday: group[:friday],
        saturday: group[:saturday],
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
