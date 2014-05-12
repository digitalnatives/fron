require 'fron/dom'

describe DOM::Events do

  let(:element) { DOM::Element.new 'div' }
  subject { element.instance_variable_get("@listeners") }

  describe '#on' do
    async 'should register for event' do
      listener = element.on 'click' do |event|
        run_async do
          subject.should_not be nil
          subject[:click].should_not be nil
          subject[:click].length.should eq 1
          subject[:click].include?(listener).should eq true
          element.off 'click'
        end
      end
      element.trigger 'click'
    end
  end

  describe '#off' do
    context "two arguments" do
      it 'should unregister for event' do
        listener = element.on 'click' do end
        subject[:click].include?(listener).should eq true
        element.off 'click', listener
        subject[:click].include?(listener).should eq false
      end
    end

    context "one argument" do
      it 'should unregister all events for type' do
        listener = element.on 'click' do end
        subject[:click].include?(listener).should eq true
        element.off 'click'
        subject[:click].include?(listener).should eq false
      end
    end

    context "no argument" do
      it 'should unregister all events' do
        listener = element.on 'click' do end
        subject[:click].include?(listener).should eq true
        element.off
        subject[:click].include?(listener).should eq false
      end
    end
  end

  describe '#delegate' do
    async 'should call the listener if the element matches the selector' do
      element.delegate 'click', 'div' do
        run_async do
          element.off 'click'
        end
      end
      element.trigger 'click'
    end
  end

  describe '#trigger' do
    async 'should trigger the event' do
      element.on 'click' do |event|
        run_async do
          element.off 'click'
        end
      end
      element.trigger 'click'
    end
  end
end
