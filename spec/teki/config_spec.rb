require 'spec_helper'

describe Teki::Config do
  describe 'load' do
    context do

      it 'parse config' do
        Teki::Config.load('~/tmp/time_base.json')
      end
    end
  end
end
