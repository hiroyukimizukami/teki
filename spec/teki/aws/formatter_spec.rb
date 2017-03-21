require 'spec_helper'

describe Teki::Aws::Formatter do
  describe 'format' do
    subject { described_class.format(params) }
    let(:params) do
      [
        Teki::Aws::TimeBasedSchedule.create(
        instance: 'i001',
        weekly_setting: {
          sunday: [0, 1, 2],
          monday: [21, 22, 23],
          tuesday: [3, 4, 5],
          wednesday: [],
          thursday: [1, 2, 22, 23],
          friday: [20],
          saturday: [0, 1, 2, 3, 4, 5, 6],
        }
      )
      ]
    end

    it { expect(subject[0][:instance_id]).to eq(params[0].instance) }
    it { expect(subject[0][:auto_scaling_schedule][:sunday].count).to eq(24) }
    it { expect(subject[0][:auto_scaling_schedule][:monday].count).to eq(24) }
    it { expect(subject[0][:auto_scaling_schedule][:tuesday].count).to eq(24) }
    it { expect(subject[0][:auto_scaling_schedule][:wednesday].count).to eq(24) }
    it { expect(subject[0][:auto_scaling_schedule][:thursday].count).to eq(24) }
    it { expect(subject[0][:auto_scaling_schedule][:friday].count).to eq(24) }
    it { expect(subject[0][:auto_scaling_schedule][:saturday].count).to eq(24) }
  end

  describe 'format_hours' do
    subject { described_class.format_hours(params) }
    let(:params) { [ 0, 1, 2, 22, 23 ] }

    it 'returns all hour setting' do
      expectation = {
        '0' => 'on',
        '1' => 'on',
        '2' => 'on',
        '3' => 'off',
        '4' => 'off',
        '5' => 'off',
        '6' => 'off',
        '7' => 'off',
        '8' => 'off',
        '9' => 'off',
        '10' => 'off',
        '11' => 'off',
        '12' => 'off',
        '13' => 'off',
        '14' => 'off',
        '15' => 'off',
        '16' => 'off',
        '17' => 'off',
        '18' => 'off',
        '19' => 'off',
        '20' => 'off',
        '21' => 'off',
        '22' => 'on',
        '23' => 'on',
      }
      expect(subject).to eq(expectation)
    end
  end
end
