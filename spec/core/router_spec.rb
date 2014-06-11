require 'fron/core'

module Fron
  class Router
    attr_reader :routes
  end
end

class TestRouteController < Fron::Controller
  route "show/:id", :show
  route "*", :test

  def show
  end
  def test
  end
end

describe Fron::Router do

  subject { described_class.new [], config }
  let(:window) { DOM::Window }
  let(:window_listeners) {window.instance_variable_get("@listeners")}
  let(:controller) { TestRouteController.new }
  let(:config) { double :config, {
      injectBlock: nil,
      logger: double(:logger,info:  true),
      main: double(:main, :"<<" => true, "empty" => true)
    }
  }

  before { window.off }

  describe "DSL" do
    describe "#map" do
      it "should retrun '*' path for action only" do
        result = described_class.map :test
        result[:path].should eq "*"
        result[:action].should eq :test
      end

      it "should return regexp for path" do
        result = described_class.map "/test", :test
        result[:path][:regexp].should eq Regexp.new "^/test"
        result[:path][:map].should eq []
        result[:action].should eq :test
      end

      it 'should parse string as action' do
        result = described_class.map :test
        result[:action].should eq :test
        result[:controller].should be nil
      end

      it 'should parse controllers as controller' do
        result = described_class.map Fron::Controller
        result[:controller].should_not be nil
        result[:controller].class.should eq Fron::Controller
        result[:action].should eq nil
      end
    end
  end

  describe "#route" do
    it "should deletage if controller is given" do
      subject.routes << {path: "*", controller: controller}
      subject.should receive(:route).twice.and_call_original
      subject.route
    end

    it "should call controller action" do
      subject.routes << {path: "*", controller: controller}
      controller.should receive(:test).once
      subject.route
    end

    it "should call controller action with params" do
      controller.should receive(:show).once.with({id: '10'})
      subject.routes << {path: "*", controller: controller}
      subject.route 'show/10'
    end

    it "should remove the matched portion of the hash" do
      controller.should receive(:show).once.with({id: '10'})
      subject.routes << {path: {regexp: Regexp.new("test/")}, controller: controller}
      subject.route 'test/show/10'
    end
  end

  describe "#applyRoute" do
    it "should call before methods" do
      controller.should receive(:empty).once
      subject.applyRoute controller, {action: 'show'}
    end

    it "should call action method" do
      controller.should receive(:show).once
      subject.applyRoute controller, {action: 'show'}
    end

    it 'should log the route' do
      config.logger.should receive(:info).once
      subject.applyRoute controller, {action: 'show'}
    end

    it "should append it the the main" do
      config.main.should receive(:<<).once
      subject.applyRoute controller, {action: 'show'}
    end
  end

  describe "#initalize" do
    it 'should listen on window load' do
      subject
      window_listeners['load'].should_not be nil
    end

    it 'should listen on window hashchange' do
      subject
      window_listeners['hashchange'].should_not be nil
    end
  end

end
