require 'spec_helper'

describe Teki::Config::WeeklySchedule do
  context 'all' do
    subject do
      described_class.create(
        sunday: { sunfoo: 'bar', sunfoo2: 'bar2' },
        monday: { monfoo: 'bar' },
        tuesday: { tuefoo: 'bar' },
        wednesday: nil,
        thursday: { thufoo: 'bar' },
        friday: { frioo: 'bar' },
        saturday: { satfoo: 'bar' },
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
