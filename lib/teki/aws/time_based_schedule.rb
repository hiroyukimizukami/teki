module Teki
  module Aws
    class TimeBasedSchedule < ::Value.new(:instance, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday)
      def self.create(instance:, weekly_setting:)
        params += weekly_setting
        with(* params)
      end
    end
  end
end
