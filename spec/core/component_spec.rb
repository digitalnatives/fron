require 'fron/core'

class TestComponent < Fron::Component
  attr_reader :rendered

  def render
    @rendered = true
  end
end

describe Fron::Component do

  subject  { TestComponent.new }
  let(:listeners) { subject.instance_variable_get("@listeners") }

  describe "DSL" do

    subject { TestComponent }

    describe "#tag" do
      it 'should set the tagname' do
        subject.tag 'td'
        subject.tagname.should eq 'td'
      end
    end

    describe "#on" do
      it 'should create events array' do
        subject.on :click, :test
        subject.events.should_not be nil
      end

      it 'should push event into the events array' do
        subject.on :click, :test
        subject.events.length.should be 2
      end
    end

    describe '#component' do
      it 'should create components array' do
        subject.component :test, 'test'
        subject.components.should_not be nil
        subject.components.length.should be 1
      end

      it 'should create attr_reader for component' do
        subject.component :a, 'a'
        subject.instance_methods.include?(:a).should be true
      end
    end

    describe '#delegate' do
      it 'should create delegated methods' do
        subject.delegate :text, :test
        subject.delegates.should_not be nil
        subject.delegates[0].should eq [:text,:test]
      end
    end
  end

  describe "#initialize" do
    it 'should create element' do
      subject.tag.should eq 'td'
    end

    it 'should apply events' do
      listeners[:click].length.should eq 2
    end

    it 'should create components' do
      subject.a.should_not be nil
      subject.a.tag.should eq 'a'

      subject.test.should_not be nil
      subject.test.tag.should be 'test'
    end

    it 'should call render if model given' do
      comp = TestComponent.new(Fron::Model.new)
      comp.rendered.should be true
    end
  end

  describe "#component" do
    it 'should create a component from a Class' do
      subject.component 'b', TestComponent
      subject.instance_variable_get("@b").class.should eq TestComponent
    end

    it 'should create a component from a String' do
      subject.component 'e', 'i'
      subject.instance_variable_get("@e").class.should eq Fron::Component
    end

    it 'should append component' do
      subject.component 'd', TestComponent
      comp = subject.instance_variable_get("@d")
      comp.parent.should eq subject
    end

    it 'should call block if block given' do
      called = false
      subject.component('c', 'x') { called = true }
      called.should be true
    end
  end
end
