require 'spec_helper'

describe ::Teki::TimeBased::DaySetting do
  subject { described_class.new(params).to_h }

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
