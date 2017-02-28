module Teki
  module TimeBased
    class WeeklySetting < ::Value.new(:sunday, :monday, :tuessday, :wednesday, :thursday, :friday, :saturday)

      def self.create(sunday:, monday:, tuesday:, wednesday:, thursday:, friday:, saturday:)
        with(
          sunday: sunday,
          monday: monday,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: thursday,
          friday: friday,
          saturday: saturday,
        )
      end
    end
  end
end
