module Teki
  module Config
    def self.load(path)
      data = open(path) do |io|
        JSON.load(io)
      end
      data
    end

    class Entry < ::Value.new(:time_zone, :layers)
      def self.create(time_zone:, layers:)
        with(time_zone: time_zone, layers: layers)
      end
    end

    class Layer < ::Value.new(:layer_name, :weekly_schedule)
      def self.create(layer_name:, weekly_schedule:)
        with(layer_name: layer_name, weekly_schedule: weekly_schedule)
      end
    end

    class WeeklySchedule < ::Value.new(:sun, :mon, :tue, :wed, :thu, :fri, :sat)
      def self.create(sun:, mon:, tue:, wed:, thu:, fri:, sat:)
        with(sun: sun, mon: mon, tue: tue, wed: wed, thu: thu, fri: fri, sat: sat)
      end

      def all
        result = {}
        [sun, mon, tue, wed, thu, fri, sat].each do |e|
          result.merge!(e) if e
        end
        result
      end
    end
  end
end
