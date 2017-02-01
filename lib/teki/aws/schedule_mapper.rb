module Teki
  module Aws
    class ScheduleMapper
      # @weekly_schedule: Teki::WeeklySchedule
      # @return Aws::OpsWorks::Types::WeeklyAutoScalingSchedule
      def self.to_weekly_auto_saling_schedule(weekly_schedule)

        # weekday+hour : instance_countの対応を作る
      end
    end
  end
end
