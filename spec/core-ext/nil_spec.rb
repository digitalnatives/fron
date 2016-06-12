require 'spec_helper'

describe NilClass do
  describe '#empty?' do
    it 'should return true' do
      subject.empty?.should eq true
    end
  end
end
