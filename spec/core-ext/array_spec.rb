require 'spec_helper'

describe Array do
  subject { %w(a b) }

  describe '#reverse_each_with_index' do
    it 'should run in reverse' do
      array = []
      subject.reverse_each_with_index do |item, index|
        array << [item, index]
      end
      array.should eq [['b', 1], ['a', 0]]
    end
  end
end
