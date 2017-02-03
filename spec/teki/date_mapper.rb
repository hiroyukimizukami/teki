require 'spec_helper'

describe Teki::DateMapper do
  let(:base_time) { Time.new(2017, 1, 1, 0, 0, 0, "+09:00") }
  let(:hour) { 3600 }
  subject { described_class.new }

  describe 'group_by_wday' do
    context do
      let(:params) do
        {
          Time.new(2017, 1, 1, 0, 0, 0, "+00:00") => 1,
          Time.new(2017, 1, 1, 1, 0, 0, "+00:00") => 2,
          Time.new(2017, 1, 1, 2, 0, 0, "+00:00") => 2,
          Time.new(2017, 1, 1, 3, 0, 0, "+00:00") => 1,
          Time.new(2017, 1, 2, 0, 0, 0, "+00:00") => 2,
          Time.new(2017, 1, 3, 0, 0, 0, "+00:00") => 2,
        }
      end
      it 'make group of time_instance' do
        result = subject.group_by_wday(params)
        expect(result[:sun]).to eq({
                                     Time.new(2017, 1, 1, 0, 0, 0, "+00:00") => 1,
                                     Time.new(2017, 1, 1, 1, 0, 0, "+00:00") => 2,
                                     Time.new(2017, 1, 1, 2, 0, 0, "+00:00") => 2,
                                     Time.new(2017, 1, 1, 3, 0, 0, "+00:00") => 1,
                                   })
        expect(result[:mon]).to eq({
                                     Time.new(2017, 1, 2, 0, 0, 0, "+00:00") => 2,
                                   })
        expect(result[:tue]).to eq({
                                     Time.new(2017, 1, 3, 0, 0, 0, "+00:00") => 2,
                                   })
      end
    end
  end

  describe 'to_utc' do
    context do
      let(:params) do
        {
          (base_time - hour * 3) => 1,
          (base_time - hour * 2) => 2,
          (base_time - hour * 1) => 2,
        }
      end

      it 'parses times to utc' do
        result = subject.to_utc(params)
        expect(result).to eq({
                               (base_time - hour * 3).getutc => 1,
                               (base_time - hour * 2).getutc => 2,
                               (base_time - hour * 1).getutc => 2,
                             })

      end
    end
  end

  describe 'to_time_instance' do
    context do
      let(:schedules) do
        [
          Teki::Schedule.create(instance_count: 4, time_range: (base_time - hour * 3)..base_time),
          Teki::Schedule.create(instance_count: 2, time_range: (base_time - hour * 6)..(base_time - hour * 1)),
        ]
      end

      it 'returns time key hash' do
        result = subject.to_time_instance(schedules)
        expect(result).to eq({
                               (base_time - hour * 6) => 2,
                               (base_time - hour * 5) => 2,
                               (base_time - hour * 4) => 2,
                               (base_time - hour * 3) => 6,
                               (base_time - hour * 2) => 6,
                               (base_time - hour * 1) => 6,
                               (base_time) => 4,
                             })
      end
    end
  end
end
