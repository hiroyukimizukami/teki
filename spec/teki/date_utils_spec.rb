require 'spec_helper'

describe Teki::DateUtils do

  describe 'step' do
    context 'step by 3600s' do
      it 'should pass stepped time to block' do
        base = Time.parse('2017-01-27 00:00:00')
        range = (base - 3600 * 3)..base

        result = []
        described_class.step(range, 3600) do |time|
          result << time.hour
        end
        expect(result).to eq([21, 22, 23, 0])
      end

    end
  end

  describe 'to_weekday' do
    context do
      it 'parse wday value to symbol' do
        expect(described_class.to_weekday(0)).to eq(:sun)
        expect(described_class.to_weekday(1)).to eq(:mon)
        expect(described_class.to_weekday(2)).to eq(:tue)
        expect(described_class.to_weekday(3)).to eq(:wed)
        expect(described_class.to_weekday(4)).to eq(:thu)
        expect(described_class.to_weekday(5)).to eq(:fri)
        expect(described_class.to_weekday(6)).to eq(:sat)
        expect { described_class.to_weekday(-1) }.to raise_error(StandardError)
      end
    end
  end

  describe 'to_weekday' do
    context do
      it 'parse weekday sym to wday value' do
        expect(described_class.to_wday(:sun)).to eq(0)
        expect(described_class.to_wday(:mon)).to eq(1)
        expect(described_class.to_wday(:tue)).to eq(2)
        expect(described_class.to_wday(:wed)).to eq(3)
        expect(described_class.to_wday(:thu)).to eq(4)
        expect(described_class.to_wday(:fri)).to eq(5)
        expect(described_class.to_wday(:sat)).to eq(6)
        expect { described_class.to_weekday(-1) }.to raise_error(StandardError)
      end
    end
  end

  describe 'to_instance_count_by_hour' do
    let(:base_time) { Time.new(2017, 1, 1, 0, 0, 0, "+09:00") }
    let(:hour) { 3600 }
    context do
      let(:schedules) do
        [
          { count: 4, time_range: (base_time - hour * 3)..base_time },
          { count: 2, time_range: (base_time - hour * 6)..(base_time - hour * 1) },
        ]
      end

      it 'returns time key hash' do
        expectation = {
          (base_time - hour * 6) => 2,
          (base_time - hour * 5) => 2,
          (base_time - hour * 4) => 2,
          (base_time - hour * 3) => 6,
          (base_time - hour * 2) => 6,
          (base_time - hour * 1) => 6,
          (base_time) => 4,
        }
        result = described_class.to_instance_count_by_hour(schedules)
        expect(result).to eq(expectation)
      end
    end
  end
end
