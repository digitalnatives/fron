require 'fron/dom'

class TestNode < DOM::NODE
  attr_reader :el
end

describe TestNode do

  subject { described_class.new `document.createElement('div')` }

  describe "#dup" do

    let(:node) { subject.dup }

    it 'should clone the node' do
      node.should_not eq subject
    end

    it 'should have the same class' do
      node.class.should eq TestNode
    end
  end

  describe "#dup!" do

    let(:node) { subject.dup! }

    it 'should clone with children' do
      subject << DOM::Element.new('div')
      subject.children.length.should eq 1
      node = subject.dup!
      node.children.length.should eq 1
    end
  end

  describe '#parent' do
    it 'should return nil if there is no parent node' do
      subject.parent.should eq nil
    end

    it 'should return a new NODE' do
      subject >> DOM::Document.body
      subject.parent.class.should eq DOM::NODE
    end
  end

  describe "#parentNode" do
    it 'should return nil if there is no parent node' do
      subject.parentNode.should eq nil
    end

    it 'should return a new NODE' do
      subject >> DOM::Document.body
      subject.parentNode.class.should eq DOM::NODE
    end
  end

  describe 'empty?' do
    it 'should return true for no children' do
      subject.empty?.should be true
    end

    it 'should return false for children' do
      subject << DOM::Element.new('div')
      subject.empty?.should be false
    end
  end

  describe 'children' do
    it 'should return a list of children' do
      subject << DOM::Element.new('div')
      subject.children.length.should be 1
    end
  end
end
