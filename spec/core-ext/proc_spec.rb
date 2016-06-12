require 'spec_helper'

describe Proc do
  describe '#debounce' do
    it 'should return Proc' do
      proc {}.debounce(10).should be_a Proc
    end
  end

  describe '#throttle' do
    it 'should return Proc' do
      proc {}.throttle(10).should be_a Proc
    end
  end
end
