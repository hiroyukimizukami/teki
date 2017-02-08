require 'spec_helper'

describe Teki::Config do
  describe 'load' do
    subject { described_class.load(config_file) }
    context do
      let(:config_file) { 'spec/resources/time_base.json' }
      it 'parse config' do
        expect(subject).to be_a(Teki::Config::Entry)
        expect(subject.timezone).to eq('+09:00')
        expect(subject.stack_name).to eq('example.com')
        expect(subject.layers).not_to eq(nil)
      end
    end
  end

  describe 'to_integer_range' do
    subject { described_class.to_integer_range(range) }
    context 'one digit' do
      let(:range) { '0-9' }
      it 'parge string_range to range object' do
        expect(subject).to eq(0..9)
      end
    end

    context 'two digit' do
      let(:range) { '12-23' }
      it 'parge string_range to range object' do
        expect(subject).to eq(12..23)
      end
    end
  end

  describe 'parse_layer' do
    subject { described_class.parse_layer(base_time, 'dev.layer.com', weekly_schedules) }
    context do
      let(:base_time) { Time.new(2017, 2, 8, 0, 0, 0, '+09:00') }
      let(:weekday) { 'mon' }
      let(:weekly_schedules) do
        {
          sun: [ { count: 4, time_range: '0-2' }, { count: 2, time_range: '22-23' } ],
          mon: [ { count: 4, time_range: '0-2' }, { count: 2, time_range: '22-23' } ],
          tue: [ { count: 4, time_range: '0-2' }, { count: 2, time_range: '22-23' } ],
          wed: [ { count: 4, time_range: '0-2' }, { count: 2, time_range: '22-23' } ],
          thu: [ { count: 4, time_range: '0-2' }, { count: 2, time_range: '22-23' } ],
          fri: nil,
          sat: [ { count: 4, time_range: '0-2' }, { count: 2, time_range: '22-23' } ],
        }
      end
      it '' do
        expect(subject).to eq(nil)
      end
    end
  end

  describe 'parse_day_schedules' do
    subject { described_class.parse_day_schedules(base_time, weekday, day_schedules) }
    context do
      let(:base_time) { Time.new(2017, 2, 8, 0, 0, 0, '+09:00') }
      let(:weekday) { 'mon' }
      let(:day_schedules) do
        [
          { count: 4, time_range: '0-2' },
          { count: 2, time_range: '22-23' }
        ]
      end
      it '' do
        expect(subject).to eq(nil)
      end
    end
  end

  describe 'to_time_range' do
    subject { described_class.to_time_range(base_time, weekday, range_string) }
    context do
      let(:base_time) { Time.new(2017, 2, 7, 23, 45, 23, "+01:00") }
      let(:weekday) { 'mon' }
      let(:range_string) { '0-2' }
      it 'create base time' do
        expectation = [
          Time.new(2017, 2, 8, 0, 0, 0, '+01:00'),
          Time.new(2017, 2, 8, 1, 0, 0, '+01:00'),
          Time.new(2017, 2, 8, 2, 0, 0, '+01:00'),
        ]
        expect(subject).to eq(expectation)
      end
    end
  end

  describe 'get_basetime' do
    subject { described_class.get_basetime(timezone) }
    context do
      let(:timezone) { '+01:00' }
      it 'create base time' do
        expect(subject.utc_offset).to eq(3600)
        expect(subject.wday).to eq(0)
      end
    end
  end

  describe 'create_time' do
    subject { described_class.create_time(base_time, wday, hour) }
    context do
      let(:base_time) { Time.new(2017, 2, 7, 23, 45, 23, "+01:00") }
      let(:wday) { 1 } # mon
      let(:hour) { 1 }
      it 'creates time' do
        expect(subject).to eq(Time.new(2017, 2, 8, 1, 0, 0, "+01:00"))
      end
    end
  end
end
