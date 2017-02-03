require 'spec_helper'

describe Teki::DateUtils do

  describe 'iterate_time' do
    context 'step by 3600s' do
      it 'should pass stepped time to block' do
        base = Time.parse('2017-01-27 00:00:00')
        range = (base - 3600 * 3)..base

        result = []
        described_class.iterate_time(range, 3600) do |time|
          result << time.hour
        end
        expect(result).to eq([21, 22, 23, 0])
      end

    end
  end

  describe 'to_wday' do
    context do
      it 'parse wday value to symbol' do
        expect(described_class.to_wday(0)).to eq(:sun)
        expect(described_class.to_wday(1)).to eq(:mon)
        expect(described_class.to_wday(2)).to eq(:tue)
        expect(described_class.to_wday(3)).to eq(:wed)
        expect(described_class.to_wday(4)).to eq(:thu)
        expect(described_class.to_wday(5)).to eq(:fri)
        expect(described_class.to_wday(6)).to eq(:sat)
        expect { described_class.to_wday(-1) }.to raise_error(StandardError)
      end
    end
  end
end
