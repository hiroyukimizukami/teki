require 'spec_helper'

describe Teki::DateMapper do
  describe 'to_time_instance' do
    subject { described_class.new }

    context do
      let(:base_time) { Time.new(2017, 1, 1, 0, 0, 0, "+09:00") }
      let(:hour) { 3600 }
      let(:schedules) do
        [
          Teki::Schedule.create(instance_count: 4, time_range: (base_time - hour * 3)..base_time),
          Teki::Schedule.create(instance_count: 2, time_range: (base_time - hour * 6)..(base_time - hour * 1)),
        ]
      end

      it 'returns time key hash' do
        result = subject.to_time_instance(base_time, schedules)
        p result
      end
    end
  end
end
