require 'spec_helper'

describe Teki::Config::WeeklySchedule do
  context 'all' do
    subject do
      described_class.create(
        sun: { sunfoo: 'bar', sunfoo2: 'bar2' },
        mon: { monfoo: 'bar' },
        tue: { tuefoo: 'bar' },
        wed: nil,
        thu: { thufoo: 'bar' },
        fri: { frioo: 'bar' },
        sat: { satfoo: 'bar' },
      ).all
    end
    it 'return all of its schedules' do
      expectation = {
        sunfoo: 'bar',
        sunfoo2: 'bar2',
        monfoo: 'bar',
        tuefoo: 'bar',
        thufoo: 'bar',
        frioo: 'bar',
        satfoo: 'bar',
      }
      expect(subject).to eq(expectation)
    end
  end
end
