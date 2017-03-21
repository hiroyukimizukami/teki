module Teki
  module Config
    class Entry < ::Value.new(:timezone, :stack_name, :layers)
      def self.create(timezone:, stack_name:, layers:)
        with(timezone: timezone, stack_name: stack_name, layers: layers)
      end
    end
  end
end
