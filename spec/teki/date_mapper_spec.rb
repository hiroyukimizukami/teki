require 'spec_helper'

describe Teki::DateTranslator do
  let(:base_time) { Time.new(2017, 1, 1, 0, 0, 0, '+09:00') }
  let(:hour) { 3600 }
  subject { described_class.new }

  describe 'map' do
    context do
      let(:sun) { Time.new(2017, 1, 1, 23, 0, 0, '+09:00') }
      let(:mon) { Time.new(2017, 1, 2, 23, 0, 0, '+09:00') }
      let(:sat) { Time.new(2017, 1, 7, 23, 0, 0, '+09:00') }
      let(:params) do
        sun_schedule = {
          (sun - hour * 3) => 1,
          (sun - hour * 2) => 1,
          (sun - hour * 1) => 1,
          sun => 1,
        }

        mon_schedule = {
          (mon - hour * 23) => 2,
          (mon - hour * 22) => 2,
          (mon - hour * 21) => 2,
          (mon - hour * 20) => 2,
          (mon - hour * 3) => 4,
          (mon - hour * 2) => 4,
          (mon - hour * 1) => 4,
          mon => 4,
        }

        sat_schedule = {
          (sat - hour * 12) => 4,
          (sat - hour * 11) => 4,
          (sat - hour * 10) => 4,
        }

        Teki::Config::WeeklySchedule.create(
          sun: sun_schedule,
          mon: mon_schedule,
          tue: nil,
          wed: nil,
          thu: nil,
          fri: nil,
          sat: sat_schedule,
        )
      end
      it 'creates instance_count for every hour' do
        sun = {
          Time.new(2017, 1, 1, 11, 0, 0, '+00:00') => 1,
          Time.new(2017, 1, 1, 12, 0, 0, '+00:00') => 1,
          Time.new(2017, 1, 1, 13, 0, 0, '+00:00') => 1,
          Time.new(2017, 1, 1, 14, 0, 0, '+00:00') => 1,
          Time.new(2017, 1, 1, 15, 0, 0, '+00:00') => 2,
          Time.new(2017, 1, 1, 16, 0, 0, '+00:00') => 2,
          Time.new(2017, 1, 1, 17, 0, 0, '+00:00') => 2,
          Time.new(2017, 1, 1, 18, 0, 0, '+00:00') => 2,
        }
        mon = {
          Time.new(2017, 1, 2, 11, 0, 0, '+00:00') => 4,
          Time.new(2017, 1, 2, 12, 0, 0, '+00:00') => 4,
          Time.new(2017, 1, 2, 13, 0, 0, '+00:00') => 4,
          Time.new(2017, 1, 2, 14, 0, 0, '+00:00') => 4,
        }
        sat = {
          Time.new(2017, 1, 7, 2, 0, 0, '+00:00') => 4,
          Time.new(2017, 1, 7, 3, 0, 0, '+00:00') => 4,
          Time.new(2017, 1, 7, 4, 0, 0, '+00:00') => 4,
        }
        result = subject.to_utc(params)
        expect(result.sun).to eq(sun)
        expect(result.mon).to eq(mon)
        expect(result.mon).to eq(mon)
        expect(result.sat).to eq(sat)
      end
    end
  end

  describe 'group_by_wday' do
    context do
      let(:params) do
        {
          Time.new(2017, 1, 1, 0, 0, 0, '+00:00') => 1,
          Time.new(2017, 1, 1, 1, 0, 0, '+00:00') => 2,
          Time.new(2017, 1, 1, 2, 0, 0, '+00:00') => 2,
          Time.new(2017, 1, 1, 3, 0, 0, '+00:00') => 1,
          Time.new(2017, 1, 2, 0, 0, 0, '+00:00') => 2,
          Time.new(2017, 1, 3, 0, 0, 0, '+00:00') => 2,
        }
      end
      it 'make group of time_instance' do
        result = subject.group_by_wday(params)
        sun = {
          Time.new(2017, 1, 1, 0, 0, 0, '+00:00') => 1,
          Time.new(2017, 1, 1, 1, 0, 0, '+00:00') => 2,
          Time.new(2017, 1, 1, 2, 0, 0, '+00:00') => 2,
          Time.new(2017, 1, 1, 3, 0, 0, '+00:00') => 1,
        }
        mon = { Time.new(2017, 1, 2, 0, 0, 0, '+00:00') => 2, }
        tue = { Time.new(2017, 1, 3, 0, 0, 0, '+00:00') => 2, }

        expect(result[:sun]).to eq(sun)
        expect(result[:mon]).to eq(mon)
        expect(result[:tue]).to eq(tue)
      end
    end
  end

  describe 'change_timezone' do
    context do
      let(:params) do
        {
          (base_time - hour * 3) => 1,
          (base_time - hour * 2) => 2,
          (base_time - hour * 1) => 2,
        }
      end

      it 'parses times to utc' do
        result = subject.change_timezone(params)
        expectation = {
          (base_time - hour * 3).getutc => 1,
          (base_time - hour * 2).getutc => 2,
          (base_time - hour * 1).getutc => 2,
        }

        expect(result).to eq(expectation)
      end
    end
  end
end
