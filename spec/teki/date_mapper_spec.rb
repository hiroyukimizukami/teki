require 'spec_helper'

describe Teki::DateMapper do
  let(:base_time) { Time.new(2017, 1, 1, 0, 0, 0, "+09:00") }
  let(:hour) { 3600 }
  subject { described_class.new }

  describe 'map' do
    context do
      let(:sun) { Time.new(2017, 1, 1, 23, 0, 0, "+09:00") }
      let(:mon) { Time.new(2017, 1, 2, 23, 0, 0, "+09:00") }
      let(:sat) { Time.new(2017, 1, 7, 23, 0, 0, "+09:00") }
      let(:params) do
        sun_range = (sun - hour * 3)..sun
        sun_schedule = Teki::Config::Schedule.create(instance_count: 1, time_range: sun_range)
        mon_range = (mon - hour * 24)..(mon - hour * 20)
        mon_schedule = Teki::Config::Schedule.create(instance_count: 2, time_range: mon_range)
        mon2_range = (mon - hour * 3)..mon
        mon2_schedule = Teki::Config::Schedule.create(instance_count: 4, time_range: mon2_range)
        sat_range = (sat - hour * 12)..(sat - hour * 10)
        sat_schedule = Teki::Config::Schedule.create(instance_count: 4, time_range: sat_range)
        Teki::Config::WeeklySchedule.create(
          sun: [sun_schedule],
          mon: [mon_schedule, mon2_schedule],
          tue: nil,
          wed: nil,
          thu: nil,
          fri: nil,
          sat: [sat_schedule]
        )
      end
      it 'creates instance_count for every hour' do
        sun = {
          Time.new(2017, 1, 1, 11, 0, 0, "+00:00") => 1,
          Time.new(2017, 1, 1, 12, 0, 0, "+00:00") => 1,
          Time.new(2017, 1, 1, 13, 0, 0, "+00:00") => 1,
          Time.new(2017, 1, 1, 14, 0, 0, "+00:00") => 3,
          Time.new(2017, 1, 1, 15, 0, 0, "+00:00") => 2,
          Time.new(2017, 1, 1, 16, 0, 0, "+00:00") => 2,
          Time.new(2017, 1, 1, 17, 0, 0, "+00:00") => 2,
          Time.new(2017, 1, 1, 18, 0, 0, "+00:00") => 2,
        }
        mon = {
          Time.new(2017, 1, 2, 11, 0, 0, "+00:00") => 4,
          Time.new(2017, 1, 2, 12, 0, 0, "+00:00") => 4,
          Time.new(2017, 1, 2, 13, 0, 0, "+00:00") => 4,
          Time.new(2017, 1, 2, 14, 0, 0, "+00:00") => 4,
        }
        sat = {
          Time.new(2017, 1, 7, 2, 0, 0, "+00:00") => 4,
          Time.new(2017, 1, 7, 3, 0, 0, "+00:00") => 4,
          Time.new(2017, 1, 7, 4, 0, 0, "+00:00") => 4,
        }
        result = subject.map(params)
        expect(result[:sun]).to eq(sun)
        expect(result[:mon]).to eq(mon)
        expect(result[:mon]).to eq(mon)
        expect(result[:sat]).to eq(sat)
      end
    end
  end

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
        sun = {
          Time.new(2017, 1, 1, 0, 0, 0, "+00:00") => 1,
          Time.new(2017, 1, 1, 1, 0, 0, "+00:00") => 2,
          Time.new(2017, 1, 1, 2, 0, 0, "+00:00") => 2,
          Time.new(2017, 1, 1, 3, 0, 0, "+00:00") => 1,
        }
        mon = { Time.new(2017, 1, 2, 0, 0, 0, "+00:00") => 2, }
        tue = { Time.new(2017, 1, 3, 0, 0, 0, "+00:00") => 2, }

        expect(result[:sun]).to eq(sun)
        expect(result[:mon]).to eq(mon)
        expect(result[:tue]).to eq(tue)
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
        expectation = {
          (base_time - hour * 3).getutc => 1,
          (base_time - hour * 2).getutc => 2,
          (base_time - hour * 1).getutc => 2,
        }

        expect(result).to eq(expectation)
      end
    end
  end

  describe 'to_time_instance' do
    context do
      let(:schedules) do
        [
          Teki::Config::Schedule.create(instance_count: 4, time_range: (base_time - hour * 3)..base_time),
          Teki::Config::Schedule.create(instance_count: 2, time_range: (base_time - hour * 6)..(base_time - hour * 1)),
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
        result = subject.to_time_instance(schedules)
        expect(result).to eq(expectation)
      end
    end
  end
end
