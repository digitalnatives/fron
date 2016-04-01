require 'spec_helper'

# Test Component
class TestComponent < Fron::Component
  attr_reader :rendered

  def render
    @rendered = true
  end
end

describe Fron::Component do
  subject { TestComponent.new }

  let(:listeners) { subject.instance_variable_get '@listeners' }
  let(:registry) { subject.instance_variable_get('@registry') }

  describe 'DSL' do
    subject { TestComponent }

    describe '#create' do
      it 'should create class' do
        test = subject.create('test')
        test.should < subject
      end
    end

    describe '#tag' do
      it 'should set the tagname' do
        subject.tag 'td'
        subject.tagname.should eq 'td'
      end
    end

    describe '#on' do
      it 'should add to registry' do
        expect {
          subject.on :click, :test
        }.to change { registry.count }.by 1
      end
    end

    describe '#component' do
      it 'should create components array' do
        expect {
          subject.component :test, 'test'
        }.to change { registry.count }.by 1
      end

      it 'should create attr_reader for component' do
        subject.component :a, 'a'
        subject.new.methods.include?(:a).should be true
      end
    end
  end

  describe '#initialize' do
    it 'should create element' do
      subject.tag.should eq 'td'
    end

    it 'should apply events' do
      listeners[:click].length.should eq 1
    end

    it 'should create components' do
      subject.a.should_not be nil
      subject.a.tag.should eq 'a'

      subject.test.should_not be nil
      subject.test.tag.should be 'test'
    end
  end

  describe '#component' do
    it 'should create a component from a Class' do
      subject.component 'b', TestComponent
      subject.instance_variable_get('@b').class.should eq TestComponent
    end

    it 'should create a component from a String' do
      subject.component 'e', 'i'
      subject.instance_variable_get('@e').class.should eq Fron::Component
    end

    it 'should append component' do
      subject.component 'd', TestComponent
      comp = subject.instance_variable_get('@d')
      comp.parent.should eq subject
    end

    it 'should call block if block given' do
      called = false
      subject.component('c', 'x') { called = true }
      called.should be true
    end
  end
end
