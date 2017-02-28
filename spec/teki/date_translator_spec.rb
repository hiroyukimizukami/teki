require 'spec_helper'

describe Teki::DateTranslator do
  let(:base_time) { Time.new(2017, 1, 1, 0, 0, 0, '+09:00') }
  let(:hour) { 3600 }
  subject { described_class.new }

  describe 'map' do
    context do
      let(:sunday) { Time.new(2017, 1, 1, 23, 0, 0, '+09:00') }
      let(:monday) { Time.new(2017, 1, 2, 23, 0, 0, '+09:00') }
      let(:saturday) { Time.new(2017, 1, 7, 23, 0, 0, '+09:00') }
      let(:params) do
        sun_schedule = {
          (sunday - hour * 3) => 1,
          (sunday - hour * 2) => 1,
          (sunday - hour * 1) => 1,
          sunday => 1,
        }

        mon_schedule = {
          (monday - hour * 23) => 2,
          (monday - hour * 22) => 2,
          (monday - hour * 21) => 2,
          (monday - hour * 20) => 2,
          (monday - hour * 3) => 4,
          (monday - hour * 2) => 4,
          (monday - hour * 1) => 4,
          monday => 4,
        }

        sat_schedule = {
          (saturday - hour * 12) => 4,
          (saturday - hour * 11) => 4,
          (saturday - hour * 10) => 4,
        }

        Teki::Config::WeeklySchedule.create(
          sunday: sun_schedule,
          monday: mon_schedule,
          tuesday: nil,
          wednesday: nil,
          thursday: nil,
          friday: nil,
          saturday: sat_schedule,
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
        expect(result.sunday).to eq(sun)
        expect(result.monday).to eq(mon)
        expect(result.saturday).to eq(sat)
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

        expect(result[:sunday]).to eq(sun)
        expect(result[:monday]).to eq(mon)
        expect(result[:tuesday]).to eq(tue)
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
