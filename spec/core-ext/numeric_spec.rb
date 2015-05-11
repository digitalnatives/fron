require 'spec_helper'

describe Numeric do
  subject { 0.5 }

  describe '#clamp' do
    it 'should clamp at minimum' do
      subject.clamp(1, 2).should eq 1
    end

    it 'should clamp at max' do
      subject.clamp(-2, -1).should eq(-1)
    end

    it 'should return value if in range' do
      subject.clamp(0, 1).should eq 0.5
    end
  end

  describe '#px' do
    it 'should return the pixel representation' do
      subject.px.should eq '1px'
    end
  end

  describe '#em' do
    it 'should return the em representation' do
      subject.em.should eq '0.5em'
    end
  end
end
