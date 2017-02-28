module Teki
  module TimeBased
    class DaySetting < ::Value.new(:hours)
      def self.create(hours)
        with(hours: hours)
      end

      def to_h
        (0..23).map do |hour|
          ret = [hour]
          ret << (hours.include?(hour) ? 'ON' : 'OFF')
          ret
        end.to_h
      end
    end
  end
end
