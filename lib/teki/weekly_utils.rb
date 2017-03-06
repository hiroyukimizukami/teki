module Teki
  module WeeklyUtils
    def self.expand_weekly_hash(hash)
      [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].map do |wday|
        [wday, hash[wday]]
      end.to_h
    end
  end
end
