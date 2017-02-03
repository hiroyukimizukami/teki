require 'spec_helper'

describe Teki::WeeklySchedule do
  context 'all' do
    subject do
      described_class.create(
        sun: [0, 1],
        mon: [1, 2],
        tue: [2, 3],
        wed: nil,
        thu: [8, 9],
        fri: [5, 6],
        sat: [10, 11],
      ).all
    end
    it 'return all of its schedules' do
      expect(subject).to eq([0, 1, 1, 2, 2, 3, 8, 9, 5, 6, 10, 11])
    end
  end
end
