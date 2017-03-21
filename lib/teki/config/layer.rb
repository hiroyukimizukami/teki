module Teki
  module Config
    class Layer < ::Value.new(:name, :weekly_schedule)
      def self.create(name:, weekly_schedule:)
        with(name: name, weekly_schedule: weekly_schedule)
      end
    end
  end
end
