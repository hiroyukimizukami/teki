require 'spec_helper'

describe ::Teki::WeeklyUtils do
  describe 'expand_weekly_hash' do
    subject { described_class.expand_weekly_hash(args) }
    let(:args) do
      {
        monday: [2, 1, 0],
        sunday: [1, 2, 3],
        tuesday: nil,
        wednesday: ['a', 'b', 'c'],
        thursday: nil,
        friday: {foo: 'bar'},
      }
    end
    it 'expands hash to argument format' do
      expect(subject[:sunday]).to match_array([1, 2, 3])
      expect(subject[:monday]).to match_array([2, 1, 0])
      expect(subject[:tuesday]).to eq(nil)
      expect(subject[:wednesday]).to eq(%w(a b c))
      expect(subject[:thursday]).to eq(nil)
      expect(subject[:friday]).to eq({foo: 'bar'})
      expect(subject[:saturday]).to eq(nil)
    end
  end
end
