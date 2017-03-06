module Teki
  module Aws
    class TimeBasedSchedule < ::Value.new(:instance, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday)
      def self.create(instance:, weekly_setting:)
        args = {instance: instance}
        args.merge!(::Teki::WeeklyUtils.expand_weekly_hash(weekly_setting))
        with(args)
      end
    end
  end
end
