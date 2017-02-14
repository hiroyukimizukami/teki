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
        pending
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
    subject { described_class.parse_layer(base_time, 'dev.layer.com', weekly_setting) }
    context do
      let(:base_time) { Time.new(2017, 2, 5, 0, 0, 0, '+09:00') }
      let(:weekly_setting) do
        {
          sun: nil,
          mon: nil,
          tue: nil,
          wed: nil,
          thu: nil,
          fri: nil,
          sat: nil,
        }
      end
      it 'returns Layer object' do
        expect(subject).to be_a(::Teki::Config::Layer)
      end
      it 'contains weekly schedule' do
        expect(subject.weekly_schedule).to be_a(::Teki::Config::WeeklySchedule)
      end
    end
  end

  describe 'parse_weekly_schedules' do
    subject { described_class.parse_weekly_schedule(base_time, weekly_setting) }
    let(:base_time) { Time.new(2017, 2, 5, 0, 0, 0, '+09:00') }
    let(:weekly_setting) do
      {
        sun: [{ count: 4, time_range: '0-2' }, { count: 2, time_range: '2-3' }],
        mon: [{ count: 3, time_range: '1-2' }],
        tue: [{ count: 2, time_range: '8-10' }],
        wed: [{ count: 4, time_range: '22-23' }],
        thu: [{ count: 5, time_range: '0-1' }],
        fri: nil,
        sat: [{ count: 1, time_range: '2-3' }],
      }
    end
    it 'contains weekly schedule' do
      expect(subject).to be_a(::Teki::Config::WeeklySchedule)
      sun = {
        Time.new(2017, 2, 5, 0, 0, 0, '+09:00') => 4,
        Time.new(2017, 2, 5, 1, 0, 0, '+09:00') => 4,
        Time.new(2017, 2, 5, 2, 0, 0, '+09:00') => 6,
        Time.new(2017, 2, 5, 3, 0, 0, '+09:00') => 2,
      }
      expect(subject.sun).to eq(sun)
    end
  end

  describe 'parse_day_schedule' do
    subject { described_class.parse_day_schedule(base_time, weekday, day_schedules) }
    context do
      let(:base_time) { Time.new(2017, 2, 5, 0, 0, 0, '+09:00') }
      let(:weekday) { 'mon' }
      let(:day_schedules) do
        [
          { count: 4, time_range: '0-2' },
          { count: 1, time_range: '1-3' },
          { count: 2, time_range: '22-23' },
        ]
      end
      it 'retruns' do
        # monday = base_time + 1 day
        expectation = {
          Time.new(2017, 2, 6, 0, 0, 0, '+09:00') => 4,
          Time.new(2017, 2, 6, 1, 0, 0, '+09:00') => 5,
          Time.new(2017, 2, 6, 2, 0, 0, '+09:00') => 5,
          Time.new(2017, 2, 6, 3, 0, 0, '+09:00') => 1,
          Time.new(2017, 2, 6, 22, 0, 0, '+09:00') => 2,
          Time.new(2017, 2, 6, 23, 0, 0, '+09:00') => 2,
        }
        expect(subject).to eq(expectation)
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

  describe 'create_week_start_time' do
    subject { described_class.create_week_start_time(timezone) }
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
