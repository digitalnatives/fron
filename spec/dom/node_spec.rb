require 'fron/dom'

class TestNode < DOM::NODE
  attr_reader :el
end

describe TestNode do

  subject { described_class.new `document.createElement('div')` }

  describe "#dup" do
    it 'should clone the node' do
      node = subject.dup
      node.class.should eq TestNode
      node.should_not eq subject
    end
  end

  describe "#dup!" do
    it 'should clone with children' do
      subject << DOM::Element.new('div')
      subject.children.length.should eq 1
      node = subject.dup!
      node.children.length.should eq 1
    end
  end

  describe "#parentNode" do

  end
end
