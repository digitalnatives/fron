require 'spec_helper'

describe DOM::Events do
  let(:element) { DOM::Element.new 'div' }

  describe '#on' do
    it 'should register for event' do
      promise = Promise.new
      listener = element.on 'click' do
        listeners = element.instance_variable_get '@listeners'
        listeners.should_not be nil
        listeners[:click].should_not be nil
        listeners[:click].length.should eq 1
        listeners[:click].include?(listener).should eq true
        promise.resolve
        element.off 'click'
      end
      element.trigger 'click'
      promise
    end
  end

  describe '#on!' do
    it 'should register for event' do
      promise = Promise.new
      listener = element.on! 'click' do
        listeners = element.instance_variable_get '@listeners'
        listeners.should_not be nil
        listeners[:click].should_not be_nil
        listeners[:click].length.should eq 1
        listeners[:click].include?(listener).should eq true
        promise.resolve
        element.off 'click'
      end
      element.trigger 'click'
      promise
    end
  end

  describe '#off' do
    context 'two arguments' do
      it 'should unregister for event' do
        listener = element.on 'click' do end
        element.instance_variable_get('@listeners')[:click]
          .include?(listener).should eq true
        element.off 'click', listener
        element.instance_variable_get('@listeners')[:click]
          .include?(listener).should eq false
      end
    end

    context 'one argument' do
      it 'should unregister all events for type' do
        listener = element.on 'click' do end
        element.instance_variable_get('@listeners')[:click]
          .include?(listener).should eq true
        element.off 'click'
        element.instance_variable_get('@listeners')[:click]
          .include?(listener).should eq false
      end
    end

    context 'no argument' do
      it 'should unregister all events' do
        listener = element.on 'click' do end
        element.instance_variable_get('@listeners')[:click]
          .include?(listener).should eq true
        element.off
        element.instance_variable_get('@listeners')[:click]
          .include?(listener).should eq false
      end
    end
  end

  describe '#delegate' do
    it 'should call the listener if the element matches the selector' do
      promise = Promise.new
      element.delegate 'click', 'div' do
        promise.resolve
        element.off 'click'
      end
      element.trigger 'click'
      promise
    end
  end

  describe '#trigger' do
    it 'should trigger the event' do
      promise = Promise.new
      element.on 'click' do
        promise.resolve
        element.off 'click'
      end
      element.trigger 'click'
      promise
    end
  end
end
