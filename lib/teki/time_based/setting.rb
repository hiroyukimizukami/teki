module Teki
  module TimeBased
    class Setting < ::Value.new(:instance_id, :schedule)
      def self.create(instance_id:, schedule:)
        with(instance_id: instance_id, schedule: schedule)
      end
    end
  end
end
