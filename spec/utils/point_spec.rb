require 'spec_helper'
require 'fron/utils/point'

describe Fron::Point do
  let(:other) { described_class.new 20, 20 }
  subject { described_class.new 10, 10 }

  describe '#-' do
    it 'should return the difference' do
      diff = subject - other
      diff.should be_a described_class
      diff.x.should eq(-10)
      diff.y.should eq(-10)
    end
  end

  describe '#+' do
    it 'should return the addition' do
      diff = subject + other
      diff.should be_a described_class
      diff.x.should eq(30)
      diff.y.should eq(30)
    end
  end

  describe '#*' do
    it 'should multipy by scalar' do
      diff = subject * 2
      diff.should be_a described_class
      diff.x.should eq(20)
      diff.y.should eq(20)
    end
  end

  describe '#/' do
    it 'should devide by scalar' do
      diff = subject / 2
      diff.should be_a described_class
      diff.x.should eq(5)
      diff.y.should eq(5)
    end
  end

  describe '#distance' do
    it 'should return the distance' do
      subject.distance.round(2).should eq 14.14
    end
  end

  describe '#to_s' do
    it 'should return string representation' do
      subject.to_s.should eq '[10, 10]'
    end
  end
end
