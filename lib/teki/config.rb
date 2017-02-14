module Teki
  module Config
    def self.load(path)
      data = open(path) do |io|
        JSON.load(io, nil, symbolize_names: true)
      end

      base_time = create_week_start_time(data[:timezone])
      layers = data[:layers].map do |name, weekly_setting|
        parse_layer(base_time, name, weekly_setting)
      end

      ::Teki::Config::Entry.create(
        timezone: data[:timezone],
        stack_name: data[:stack_name],
        layers: layers,
      )
    end

    def self.parse_layer(base_time, name, weekly_setting)
      weekly_schedule = parse_weekly_schedule(base_time, weekly_setting)
      ::Teki::Config::Layer.create(name: name, weekly_schedule: weekly_schedule)
    end

    def self.parse_weekly_schedule(base_time, weekly_setting)
      ::Teki::Config::WeeklySchedule.create(
        sun: parse_day_schedule(base_time, :sun, weekly_setting[:sun]),
        mon: parse_day_schedule(base_time, :mon, weekly_setting[:mon]),
        tue: parse_day_schedule(base_time, :tue, weekly_setting[:tue]),
        wed: parse_day_schedule(base_time, :wed, weekly_setting[:wed]),
        thu: parse_day_schedule(base_time, :thu, weekly_setting[:thu]),
        fri: parse_day_schedule(base_time, :fri, weekly_setting[:fri]),
        sat: parse_day_schedule(base_time, :sat, weekly_setting[:sat]),
      )
    end

    def self.parse_day_schedule(base_time, weekday, day_schedules)
      result = {}
      return result if day_schedules.nil?
      day_schedules.map do |schedule|
        count = schedule[:count]
        to_time_range(base_time, weekday, schedule[:time_range]).map do |time|
          result[time] = 0 if result[time].nil?
          result[time] += count
        end
      end
      result
    end

    # Implementing
    def self.to_time_range(base_time, weekday, range_string)
      wday = ::Teki::DateUtils.to_wday(weekday)
      int_range = to_integer_range(range_string)
      raise ArgumentError, "Invalid Range: #{range_string}" if int_range.begin > int_range.end
      int_range.map do |i|
        create_time(base_time, wday, i)
      end
    end

    def self.create_week_start_time(timezone)
      now = Time.now.utc
      day = now.day - now.wday
      Time.new(now.year, now.month, day, 0, 0, 0, timezone)
    end

    def self.create_time(base_time, wday, hour)
      day = base_time.day + wday
      Time.new(base_time.year, base_time.month, day, hour, 0, 0, base_time.utc_offset)
    end

    def self.to_integer_range(range_string)
      range = range_string.split('-').map { |s| s.to_i }
      range[0]..range[1]
    end

    # いらないかも..
    def self.to_instance_count_by_hour(schedules)
      result = {}
      schedules.each do |schedule|
        Teki::DateUtils.step(schedule[:time_range], Teki::DateUtils::HOUR) do |time|
          result[time] = result[time].nil? ? schedule[:count] : result[time] + schedule[:count]
        end
      end
      result
    end

    class Entry < ::Value.new(:timezone, :stack_name, :layers)
      def self.create(timezone:, stack_name:, layers:)
        with(timezone: timezone, stack_name: stack_name, layers: layers)
      end
    end

    class Layer < ::Value.new(:name, :weekly_schedule)
      def self.create(name:, weekly_schedule:)
        with(name: name, weekly_schedule: weekly_schedule)
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
