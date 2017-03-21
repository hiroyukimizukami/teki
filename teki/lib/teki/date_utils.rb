module Teki
  class DateUtils
    WDAY_MAP = {sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6}

    def self.supplement_wday(hash)
      [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].map do |wday|
        [wday, hash[wday] ]
      end.to_h
    end

    def self.to_weekday(wday)
      val = WDAY_MAP.invert[wday]
      raise 'Invalid wday' unless val
      val
    end

    def self.to_wday(weekday)
      val = WDAY_MAP[weekday.to_sym]
      raise 'Invalid weekday' unless val
      val
    end
  end
end
