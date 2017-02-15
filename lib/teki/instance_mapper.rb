module Teki
  class InstanceMapper
    def map(entry, layers)
    end

    def prioritize(instances)
      grouped = instances.group_by { |i| i.availability_zone }.sort.to_h
      grouped = grouped.map do |k, v|
        v.sort_by(&:hostname)
      end

      result = []
      count = grouped.count
      while grouped.flatten.count > 0 do
        (0...count).each do |i|
          next if grouped[i].empty?
          result << grouped[i].shift
        end
      end
      result
    end
  end
end
