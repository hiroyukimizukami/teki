module Teki
  module Config
    def self.load(path)
      data = open(path) do |io|
        JSON.load(io, nil, symbolize_names: true)
      end

      base_time = create_week_start_time(data[:timezone])
      layers = data[:layers].map do |name, weekly_setting|
        parse_layer(base_time, name.to_s, weekly_setting)
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
        sunday: parse_day_schedule(base_time, :sunday, weekly_setting[:sunday]),
        monday: parse_day_schedule(base_time, :monday, weekly_setting[:monday]),
        tuesday: parse_day_schedule(base_time, :tuesday, weekly_setting[:tuesday]),
        wednesday: parse_day_schedule(base_time, :wednesday, weekly_setting[:wednesday]),
        thursday: parse_day_schedule(base_time, :thursday, weekly_setting[:thursday]),
        friday: parse_day_schedule(base_time, :friday, weekly_setting[:friday]),
        saturday: parse_day_schedule(base_time, :saturday, weekly_setting[:saturday]),
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
      unixtime = now.to_i
      start = Time.at(unixtime - now.wday * 24 * 60 * 60).utc
      Time.new(start.year, start.month, start.day, 0, 0, 0, timezone)
    end

    def self.create_time(base_time, wday, hour)
      day = base_time.day + wday
      Time.new(base_time.year, base_time.month, day, hour, 0, 0, base_time.utc_offset)
    end

    def self.to_integer_range(range_string)
      range = range_string.split('-').map { |s| s.to_i }
      range[0]..range[1]
    end
  end
end
