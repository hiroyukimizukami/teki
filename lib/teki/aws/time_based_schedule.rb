module Teki
  module Aws
    class TimeBasedSchedule < ::Value.new(:instance, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday)
      def self.create(instance:, weekly_setting:)
      end
    end
  end
end
