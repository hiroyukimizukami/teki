require 'spec_helper'

describe ::Teki::InstanceMapper do
  describe 'prioritize' do
    subject { described_class.new.prioritize(instances) }
    let(:instances) do
      [
        create(:aws_instance, availability_zone: 'ap-northeast-1a'),
        create(:aws_instance, availability_zone: 'ap-northeast-1a'),
        create(:aws_instance, availability_zone: 'ap-northeast-1a'),
        create(:aws_instance, availability_zone: 'ap-northeast-1c'),
        create(:aws_instance, availability_zone: 'ap-northeast-1c'),
        create(:aws_instance, availability_zone: 'ap-northeast-1a'),
        create(:aws_instance, availability_zone: 'ap-northeast-1c'),
      ]
    end
    context do
      it 'prioritize instances' do
        expect(subject).to eq(nil)
      end
    end
  end
end
