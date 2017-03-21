module Teki
  module Aws
    class Formatter
      def self.format(time_based_schedule)
        {
          instance_id: time_based_schedule.instance,
          auto_scaling_schedule: {
            sunday: format_hours(time_based_schedule.sunday),
            monday: format_hours(time_based_schedule.monday),
            tuesday: format_hours(time_based_schedule.tuesday),
            wednesday: format_hours(time_based_schedule.wednesday),
            thursday: format_hours(time_based_schedule.thursday),
            friday: format_hours(time_based_schedule.friday),
            saturday: format_hours(time_based_schedule.saturday),
          }
        }
      end

      def self.format_hours(hours)
        array = (0..23).map do |hour|
          switch = hours.include?(hour) ? 'on' : 'off'
          [hour.to_s, switch]
        end.flatten
        Hash[*array]
      end
    end
  end
end
