module Teki
  module Aws
    class ScheduleTranslator
      def to_time_based_auto_scaling_request(weeklly_schedule)
      end

      def to_instance_based_schedule(weekly_schedule)
        result = {}
        weekly_schedule.keys.each do |day|
          schedule = to_instance_based_day_schedule(weekly_schedule.get(day))
          next if schedule.nil?

          schedule.each do |k, v|
            result[k] = {} if result[k].nil?
            result[k][day] = [] if result[k][day].nil?
            result[k][day] << v
            result[k][day].flatten!
          end
        end
        result
      end

      def to_instance_based_day_schedule(day_schedule)
        return if day_schedule.nil?
        result = {}
        day_schedule.map do |time, instances|
          instances.each do |instance|
            result[instance.instance_id] = [] unless result[instance.instance_id]
            result[instance.instance_id] << time.hour
          end
        end
        result
      end
    end
  end
end
