require 'spec_helper'

describe Teki::DateUtils do
  describe 'supplement_wday' do
    subject { described_class.supplement_wday(param) }
    let(:param) { { monday: 1, friday: 2 } }
    it 'supplements missing wday' do
      expect(subject.key?(:sunday)).to eq(true)
      expect(subject[:monday]).to eq(1)
      expect(subject.key?(:tuesday)).to eq(true)
      expect(subject.key?(:wednesday)).to eq(true)
      expect(subject.key?(:thursday)).to eq(true)
      expect(subject[:friday]).to eq(2)
      expect(subject.key?(:saturday)).to eq(true)
    end
  end

  describe 'to_weekday' do
    context do
      it 'parse wday value to symbol' do
        expect(described_class.to_weekday(0)).to eq(:sunday)
        expect(described_class.to_weekday(1)).to eq(:monday)
        expect(described_class.to_weekday(2)).to eq(:tuesday)
        expect(described_class.to_weekday(3)).to eq(:wednesday)
        expect(described_class.to_weekday(4)).to eq(:thursday)
        expect(described_class.to_weekday(5)).to eq(:friday)
        expect(described_class.to_weekday(6)).to eq(:saturday)
        expect { described_class.to_weekday(-1) }.to raise_error(StandardError)
      end
    end
  end

  describe 'to_weekday' do
    context do
      it 'parse weekday sym to wday value' do
        expect(described_class.to_wday(:sunday)).to eq(0)
        expect(described_class.to_wday(:monday)).to eq(1)
        expect(described_class.to_wday(:tuesday)).to eq(2)
        expect(described_class.to_wday(:wednesday)).to eq(3)
        expect(described_class.to_wday(:thursday)).to eq(4)
        expect(described_class.to_wday(:friday)).to eq(5)
        expect(described_class.to_wday(:saturday)).to eq(6)
        expect { described_class.to_weekday(-1) }.to raise_error(StandardError)
      end
    end
  end
end
