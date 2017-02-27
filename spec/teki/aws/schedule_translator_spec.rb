require 'spec_helper'

describe Teki::Aws::ScheduleTranslator do
  describe 'to_instance_based_schedule' do
    subject { described_class.new.to_instance_based_schedule(weekly_schedule) }

    let(:a1) { create(:aws_instance, instance_id: 'i001', hostname: 'a1', availability_zone: 'ap-northeast-1a') }
    let(:c1) { create(:aws_instance, instance_id: 'i002', hostname: 'c1', availability_zone: 'ap-northeast-1c') }
    let(:a2) { create(:aws_instance, instance_id: 'i003', hostname: 'a2', availability_zone: 'ap-northeast-1a') }
    let(:c2) { create(:aws_instance, instance_id: 'i004', hostname: 'c2', availability_zone: 'ap-northeast-1c') }
    let(:key_time1) { Time.parse('2017-02-21 00:00:00 +00:00') }
    let(:key_time2) { Time.parse('2017-02-21 01:00:00 +00:00') }
    let(:key_time3) { Time.parse('2017-02-24 03:00:00 +00:00') }
    let(:mon_schedule) { { key_time1 => [a1, c1], key_time2 => [a1] } }
    let(:fri_schedule) { { key_time3 => [a1, c1, a2, c2]} }
    let(:weekly_schedule) do
      Teki::Config::WeeklySchedule.create(sun: nil, mon: mon_schedule, tue: nil, wed: nil, thu: nil, fri: fri_schedule, sat: nil)
    end

    context do
      it do
        expectation = {
          'i001' => {
            mon: [0, 1],
            fri: [3],
          },
          'i002' => {
            mon: [0],
            fri: [3],
          },
          'i003' => {
            fri: [3],
          },
          'i004' => {
            fri: [3],
          },
        }
        expect(subject).to eq(expectation)
      end
    end
  end

  describe 'to_instance_based_day_schedule' do
    subject { described_class.new.to_instance_based_day_schedule(day_schedule) }

    let(:a1) { create(:aws_instance, instance_id: 'i001', hostname: 'a1', availability_zone: 'ap-northeast-1a') }
    let(:a2) { create(:aws_instance, instance_id: 'i002', hostname: 'a2', availability_zone: 'ap-northeast-1a') }
    let(:key_time1) { Time.parse('2017-02-21 00:00:00 +00:00') }
    let(:key_time2) { Time.parse('2017-02-21 01:00:00 +00:00') }
    let(:day_schedule) { { key_time1 => [a1, a2], key_time2 => [a1] } }

    context do
      it do
        expectation = {
          'i001' => [0, 1],
          'i002' => [0]
        }
        expect(subject).to eq(expectation)
      end
    end
  end
end