module Teki
  module Config
    class WeeklySchedule < ::Value.new(:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday)
      def self.create(sunday:, monday:, tuesday:, wednesday:, thursday:, friday:, saturday:)
        with(sunday: sunday, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday)
      end

      def to_h
        {
          sunday: sunday,
          monday: monday,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: thursday,
          friday: friday,
          saturday: saturday,
        }
      end

      def all
        result = {}
        [sunday, monday, tuesday, wednesday, thursday, friday, saturday].each do |e|
          result.merge!(e) if e
        end
        result
      end
    end
  end
end
