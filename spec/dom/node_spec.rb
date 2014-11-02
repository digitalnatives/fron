require 'spec_helper'

# Test Node
class TestNode < DOM::NODE
  attr_reader :el
end

describe TestNode do

  let(:el)   { DOM::Element.new('div') }
  let(:body) { DOM::Document.body }
  subject    { described_class.new `document.createElement('div')` }

  after do
    subject.remove!
    el.remove!
  end

  describe '#dup' do

    let(:node) { subject.dup }

    it 'should clone the node' do
      node.should_not eq subject
    end

    it 'should have the same class' do
      node.class.should eq TestNode
    end
  end

  describe '#dup!' do
    it 'should clone with children' do
      subject << el
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
      subject >> body
      subject.parent.should be_a DOM::NODE
    end
  end

  describe '#parentNode' do
    it 'should return nil if there is no parent node' do
      subject.parentNode.should eq nil
    end

    it 'should return a new NODE' do
      subject >> body
      subject.parentNode.should be_a DOM::NODE
    end
  end

  describe '#empty?' do
    it 'should return true for no children' do
      subject.empty?.should be true
    end

    it 'should return false for children' do
      subject << el
      subject.empty?.should be false
    end
  end

  describe '#children' do
    it 'should return a list of children' do
      subject << el
      subject.children.length.should be 1
      subject.children.class.should eq DOM::NodeList
    end
  end

  describe '#remove' do
    it 'should remove the given node from this node' do
      subject << el
      el.parent.should_not eq nil
      subject.remove el
      el.parent.should eq nil
    end
  end

  describe '#remove!' do
    it 'should remove the node for its parent node' do
      subject >> body
      subject.parent.should_not eq nil
      subject.remove!
      subject.parent.should eq nil
    end
  end

  describe '#<<' do
    it 'should append given node to the node' do
      subject << el
      subject.children.length.should eq 1
      el.parent.should_not be nil
      el.parent.should eq subject
      subject.children.include?(el).should be true
    end
  end

  describe '#>>' do
    it 'should append the node to the given node' do
      subject >> body
      subject.parent.should_not be nil
      subject.parent.should eq body
    end
  end

  describe '#insertBefore' do
    let(:otherEl) { DOM::Element.new 'div' }

    it 'should insert given node before the other given node' do
      subject << el
      subject << otherEl
      (el > otherEl).should eq true
      otherEl.should < el
    end
  end

  describe '#text' do
    it 'should return the nodes textContent' do
      `#{subject.el}.textContent = 'Test'`
      subject.text.should eq 'Test'
    end
  end

  describe '#text=' do
    it 'should set the nodes textContent' do
      subject.text = 'Asd'
      `#{subject.el}.textContent`.should eq 'Asd'
    end
  end

  describe '#normalize!' do
    it 'should normalize the node' do
      subject << DOM::Text.new('a')
      subject << DOM::Text.new('b')
      subject.children.length.should eq 2
      subject.normalize!
      subject.children.length.should eq 1
    end
  end

  describe '#==' do
    it 'should return true for same el' do
      subject >> el
      subject.should == el.children[0]
    end

    it 'should return false for not same el' do
      expect(subject != el).to eq true
    end
  end

  describe '<=>' do
    it 'should return 0 if nodes are the same' do
      subject >> el
      expect(el.children[0] <=> subject).to eq 0
    end

    it 'should throw if the nodes are not in the same parent' do
      subject >> body
      expect(proc { el <=> subject }).to raise_error
    end

    it 'should compare indexes if the nodes are in the same parent' do
      subject >> body
      el >> body
      expect(el <=> subject).to eq(-1)
      expect(subject <=> el).to eq 1
    end
  end

  describe 'index' do
    it 'should return index (position) of the node' do
      el << DOM::Element.new('test')
      subject >> el
      subject.index.should eq 1
    end
  end
end
