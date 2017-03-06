require 'spec_helper'
describe ::Teki::Aws::TimeBasedSchedule do
  describe 'create' do
    subject { described_class.create(instance: instance, weekly_setting: args) }

    let(:instance) { 'i001' }
    let(:args) {
      {
        monday: [1, 3, 4],
        saturday: [2, 3],
      }
    }
    it 'returns filled object' do
      expect(subject.instance).to eq(instance)
      expect(subject.sunday).to eq(nil)
      expect(subject.monday).to match_array([1, 3, 4])
      expect(subject.tuesday).to eq(nil)
      expect(subject.wednesday).to eq(nil)
      expect(subject.thursday).to eq(nil)
      expect(subject.friday).to eq(nil)
      expect(subject.saturday).to match_array([2, 3])
    end
  end
end
