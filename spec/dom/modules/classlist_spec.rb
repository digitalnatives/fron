require 'spec_helper'

describe DOM::ClassList do
  let(:element) { DOM::Element.new 'div' }

  describe '#add_class' do
    it 'should add a class' do
      element.add_class 'test'
      element['class'].should eq 'test'
    end

    it 'should add multiple classes' do
      element.add_class 'test', 'help'
      element['class'].should eq 'test help'
    end
  end

  describe '#remove_class' do
    before do
      element['class'] = 'test help'
    end

    it 'should add a class' do
      element.remove_class 'test'
      element['class'].should eq 'help'
    end

    it 'should add multiple classes' do
      element.remove_class 'test', 'help'
      element['class'].should eq nil
    end
  end

  describe '#has_class' do
    it 'should return true if the element has given class' do
      element['class'] = 'test'
      element.has_class('test').should eq true
    end

    it 'should return flase if the element does not have the given class' do
      element.has_class('test').should eq false
    end
  end

  describe '#toggle_class' do
    before do
      element['class'] = 'test'
    end

    it 'should remove class if the element has the given class' do
      element.toggle_class 'test'
      element['class'].should eq nil
    end

    it 'should add class if the element does not have the given class' do
      element.toggle_class 'help'
      element['class'].should eq 'test help'
    end

    it 'should add class if the second argument is true' do
      element.toggle_class 'help', true
      element['class'].should eq 'test help'
    end

    it 'should remove class if the second argument if false' do
      element.toggle_class 'test', false
      element['class'].should eq nil
    end
  end
end
