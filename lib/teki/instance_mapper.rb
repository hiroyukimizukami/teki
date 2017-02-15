module Teki
  class InstanceMapper
    def map(entry, layers)
    end

    def prioritize(instances)
      grouped = instances.group_by { |i| i.availability_zone }
      grouped = grouped.map do |k, v|
        v.sort { |e1, e2| e1.hostname <=> e2.hostname }
      end.flatten

      p grouped.count
      p grouped.map(&:availability_zone)

      # count = grouped.count
      # (0..count).each do |i|
      #   result <<
      # end
    end
  end
end
