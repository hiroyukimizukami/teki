module Teki

  def load(path)
    #TODO
    # get basetime
    # return Config.new
  end

  class Config < ::Value.new(:time_zone, :layers)
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
  class WeeklySchedule < ::Value.new(:sun, :mon, :tue, :wed, :thu, :fri, :sat)
    def self.create(sun:, mon:, tue:, wed:, thu:, fri:, sat:)
      with(sun: sun, mon: mon, tue: tue, wed: wed, thu: thu, fri: fri, sat: sat)
    end

    def all
      [sun, mon, tue, wed, thu, fri, sat].flatten.compact
    end
  end

  # istance_count: 1 or even integer
  # time_range:
  class Schedule < ::Value.new(:instance_count, :time_range)
    def self.create(instance_count:, time_range:)
      with(instance_count: instance_count, time_range: time_range)
    end
  end
end
