require 'spec_helper'

describe ::Teki::InstanceMapper do
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
