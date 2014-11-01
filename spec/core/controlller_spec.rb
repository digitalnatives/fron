require 'spec_helper'

class TestController < Fron::Controller
end

describe TestController do

  subject { described_class.new }

  describe 'DSL' do

    subject { TestController }

    describe '#base' do
      it 'should set the baseComponent' do
        subject.base Fron::Component
        subject.baseComponent.should eq Fron::Component
      end
    end

    describe '#route' do
      it 'should set routes map' do
        allow(Fron::Router).to receive(:map)
        subject.route '/', :test
        subject.routes.should_not be nil
        subject.routes.length.should eq 1
      end

      it 'should call Router.map' do
        expect(Fron::Router).to receive(:map).once
        subject.route '/a', :a
      end
    end

    describe '#on' do
      it 'should set events array' do
        subject.on :event, :action
        subject.events.should_not be nil
        subject.events[0].should eq(name: :event, action: :action)
      end
    end

    describe '#before' do
      it 'should set before filters' do
        subject.before :method, :action
        subject.beforeFilters.should_not be nil
        subject.beforeFilters[0].should eq(method: :method, actions: :action)
      end
    end
  end

  describe '#initialize' do
    it 'should create Element if no component is specified' do
      TestController.base nil
      subject.base.class.should eq DOM::Element
    end

    it 'should create component if component is specified' do
      TestController.base Fron::Component
      subject.base.class.should eq Fron::Component
    end

    it 'should call Eventable.on for event' do
      expect(Fron::Eventable).to receive(:on).once.with 'event'
      subject
    end
  end
end
