require 'fron/core'

class TestEventable
  include Fron::Eventable
end

describe Fron::Eventable do

  subject { described_class }
  let(:events) { subject.instance_variable_get("@events") }
  let(:instance) { TestEventable.new }

  describe "#on" do
    it "should add to events array" do
      subject.on 'event' do end
      events.should_not be nil
      events[:event].should_not be nil
    end

    it "should add block to events array" do
      a = Proc.new {}
      subject.on 'event', &a
      events[:event].last.should eq a
    end
  end

  describe "#trigger" do
    it "should not trigger global event if called on self" do
      expect(subject).to receive(:trigger).once.and_call_original
      subject.trigger 'test'
    end

    it "should trigger global event if specified and not self" do
      expect(subject).to receive(:trigger).once.and_call_original
      instance.on 'test' do end
      instance.trigger 'test'
    end

    it "should not trigger global event if not specified" do
      expect(subject).not_to receive(:trigger)
      instance.trigger 'test', false
    end

    it "should call listeners" do
      a = Proc.new {}
      expect(a).to receive(:call)
      instance.on 'test', &a
      instance.trigger 'test'
    end
  end

  describe "#off" do
    it "should remove the block from the events array" do
      block = subject.on 'test' do end
      events['test'].last.should eq block
      subject.off 'test', block
      events['test'].last.should_not eq block
    end

    it 'should remove all corressponding events' do
      subject.on 'test' do end
      events['test'].length.should_not be 0
      subject.off 'test'
      events['test'].length.should be 0
    end

    it 'should remove all events' do
      subject.on 'test' do end
      events.keys.length.should eq 2
      subject.off
      events.keys.length.should eq 0
    end
  end
end
