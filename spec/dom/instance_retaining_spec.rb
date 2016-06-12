require 'spec_helper'

describe DOM::NODE do
  let(:el) { `document.createElement('div')` }
  subject { described_class.new el }

  describe '#from_node' do
    it 'should return the same instance if present' do
      subject
      described_class.from_node(el).should equal subject
    end

    it 'should create new instance if no instance present' do
      described_class.from_node(el).should be_a DOM::NODE
    end
  end
end

# Test Component
class RetainingComponent < Fron::Component
  tag 'retaining'

  component :test, 'test'
end

describe 'Intance retaining' do
  let(:el) { RetainingComponent.new }

  describe 'find' do
    it 'should return component' do
      DOM::Document.body << el
      el1 = DOM::Document.body.find('retaining')
      el1.should equal el
    end
  end

  describe 'parent' do
    it 'should return the component' do
      el.test.parent.should equal el
      el.test.parent_node.should equal el
    end
  end

  describe 'children' do
    it 'should contain the sub component' do
      el.children[0].should equal el.test
    end
  end

  describe 'event' do
    it 'target should be the same instance' do
      el.on 'click' do |event|
        event.target.should equal el
      end
      el.trigger 'click'
    end
  end
end
