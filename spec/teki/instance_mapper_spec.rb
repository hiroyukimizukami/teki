require 'spec_helper'

describe ::Teki::InstanceMapper do
  describe 'to_time_based_autoacaling_params' do
    subject { described_class.new.complement_hours(params) }

    context do
      let(:params) { [0, 1, 22, 23] }

      it do
        expectation = {
          0 => 'ON', 1 => 'ON', 2 => 'OFF', 3 => 'OFF', 4 => 'OFF', 5 => 'OFF', 6 => 'OFF',
          7 => 'OFF', 8 => 'OFF', 9 => 'OFF', 10 => 'OFF', 11 => 'OFF', 12 => 'OFF', 13 => 'OFF',
          14 => 'OFF', 15 => 'OFF', 16 => 'OFF', 17 => 'OFF', 18 => 'OFF', 19 => 'OFF', 20 => 'OFF',
          21 => 'OFF', 22 => 'ON', 23 => 'ON',
        }
        expect(subject).to eq(expectation)
      end
    end
  end

  describe 'to_instance_based_schedule' do
    subject { described_class.new.to_instance_based_schedule(weekly_schedule) }

    let(:a1) { create(:aws_instance, instance_id: 'i001', hostname: 'a1', availability_zone: 'ap-northeast-1a') }
    let(:c1) { create(:aws_instance, instance_id: 'i002', hostname: 'c1', availability_zone: 'ap-northeast-1c') }
    let(:a2) { create(:aws_instance, instance_id: 'i003', hostname: 'a2', availability_zone: 'ap-northeast-1a') }
    let(:c2) { create(:aws_instance, instance_id: 'i004', hostname: 'c2', availability_zone: 'ap-northeast-1c') }
    let(:key_time1) { Time.parse('2017-02-21 00:00:00 +00:00') }
    let(:key_time2) { Time.parse('2017-02-21 01:00:00 +00:00') }
    let(:key_time3) { Time.parse('2017-02-24 03:00:00 +00:00') }
    let(:monday_schedule) { { key_time1 => [a1, c1], key_time2 => [a1] } }
    let(:friday_schedule) { { key_time3 => [a1, c1, a2, c2]} }
    let(:weekly_schedule) do
      Teki::Config::WeeklySchedule.create(
        sunday: nil,
        monday: monday_schedule,
        tuesday: nil,
        wednesday: nil,
        thursday: nil,
        friday: friday_schedule,
        saturday: nil
      )
    end

    context do
      it do
        expectation = {
          'i001' => {
            monday: [0, 1],
            friday: [3],
          },
          'i002' => {
            monday: [0],
            friday: [3],
          },
          'i003' => {
            friday: [3],
          },
          'i004' => {
            friday: [3],
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

  describe 'assign_instance' do
    subject { described_class.new.assign_instance(day_schedule, instances) }

    let(:a1) { create(:aws_instance, hostname: 'a1', availability_zone: 'ap-northeast-1a') }
    let(:a2) { create(:aws_instance, hostname: 'a2', availability_zone: 'ap-northeast-1a') }
    let(:a3) { create(:aws_instance, hostname: 'a3', availability_zone: 'ap-northeast-1a') }
    let(:a4) { create(:aws_instance, hostname: 'a4', availability_zone: 'ap-northeast-1a') }
    context 'basic' do
      let(:key_time1) { Time.parse('2017-02-21 00:00:00 +00:00') }
      let(:key_time2) { Time.parse('2017-02-21 01:00:00 +00:00') }
      let(:day_schedule) { {key_time1 => 3, key_time2 => 1} }
      let(:instances) { [a1, a2, a3, a4 ]  }

      it { expect(subject[key_time1]).to eq([a1, a2, a3]) }
      it { expect(subject[key_time2]).to eq([a1]) }
    end

    context 'instance count shorage' do
      let(:key_time1) { Time.parse('2017-02-21 00:00:00 +00:00') }
      let(:day_schedule) { {key_time1 => 5 } }
      let(:instances) { [a1, a2, a3, a4 ] }

      it { expect{ subject }.to raise_error(StandardError) }
    end
  end

  describe 'prioritize' do
    subject { described_class.new.prioritize(instances) }

    let(:a1) { create(:aws_instance, hostname: 'a1', availability_zone: 'ap-northeast-1a') }
    let(:a2) { create(:aws_instance, hostname: 'a2', availability_zone: 'ap-northeast-1a') }
    let(:a3) { create(:aws_instance, hostname: 'a3', availability_zone: 'ap-northeast-1a') }
    let(:c1) { create(:aws_instance, hostname: 'c1', availability_zone: 'ap-northeast-1c') }
    let(:c2) { create(:aws_instance, hostname: 'c2', availability_zone: 'ap-northeast-1c') }
    let(:a4) { create(:aws_instance, hostname: 'a4', availability_zone: 'ap-northeast-1a') }
    let(:c3) { create(:aws_instance, hostname: 'c3', availability_zone: 'ap-northeast-1c') }

    context 'when some instances in every AZ' do
      let(:instances) { [a4, c1, c3, a2, c2, a1, a3] }

      it 'prioritize instances by az and hostname' do
        az = subject.map(&:availability_zone)
        expect(subject[0]).to be(a1)
        expect(subject[1]).to be(c1)
        expect(subject[2]).to be(a2)
        expect(subject[3]).to be(c2)
        expect(subject[4]).to be(a3)
        expect(subject[5]).to be(c3)
        expect(subject[6]).to be(a4)
      end
    end

    context 'when a instances in every AZ' do
      let(:instances) { [a3, a1, a2, c1] }
      it 'prioritize instances' do
        expect(subject[0]).to be(a1)
        expect(subject[1]).to be(c1)
        expect(subject[2]).to be(a2)
        expect(subject[3]).to be(a3)
      end
    end

    context 'when some instances in either AZ' do
      let(:instances) { [a3, a1, a2] }
      it 'prioritize instances' do
        expect(subject[0]).to be(a1)
        expect(subject[1]).to be(a2)
        expect(subject[2]).to be(a3)
      end
    end

    context 'when a instances in either AZ' do
      let(:instances) { [a1] }
      it 'prioritize instances' do
        expect(subject[0]).to be(a1)
      end
    end
  end
end
