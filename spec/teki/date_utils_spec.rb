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

end
