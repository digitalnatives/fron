require 'spec_helper'

describe Array do
  subject { %w(a b a) }

  describe '#reverse_each_with_index' do
    it 'should run in reverse' do
      array = []
      subject.reverse_each_with_index do |item, index|
        array << [item, index]
      end
      array.should eq [['a', 2], ['b', 1], ['a', 0]]
    end
  end

  describe '#sort_by!' do
    it 'should sort the array in place' do
      result = subject.sort_by! { |item| item }
      result.should eq subject
      subject.should eq %w(a a b)
    end
  end
end
