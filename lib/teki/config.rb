module Teki

  def load(path)
    #TODO
    # get basetime
    # return Config.new
  end

  class Config < ::Value.new(:layers)
    def self.create(time_zone:, layers:)
      with(time_zone: time_zone, layers: layers)
    end
  end

  class Layer < ::Value.new(:layer_name, :schedules)
    # layer_name: String
    # schedules: [Teki::Schedule]
    def self.create(layer_name:, schedules:)
      with(layer_name: layer_name, schedules: schedules)
    end
  end

  # base_time: Time object
  # args: [Teki::Schedule]
  class WeeklySchedule < ::Value.new(:base_time, :sun, :mon, :tue, :wed, :thu, :fri, :sat)
  end

  # istance_count: 1 or even integer
  # hours: array of 0-23 itenger  [0, 1, 2]
  class Schedule < ::Value.new(:instance_count, :hours)
  end
end
