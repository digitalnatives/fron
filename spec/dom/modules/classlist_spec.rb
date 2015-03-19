require 'spec_helper'

describe DOM::ClassList do
  let(:element) { DOM::Element.new 'div' }
  subject { element['class'] }

  describe '#add_class' do
    it 'should add a class' do
      element.add_class 'test'
      subject.should eq 'test'
    end

    it 'should add multiple classes' do
      element.add_class 'test', 'help'
      subject.should eq 'test help'
    end
  end

  describe '#remove_class' do
    before do
      element['class'] = 'test help'
    end

    it 'should add a class' do
      element.remove_class 'test'
      subject.should eq 'help'
    end

    it 'should add multiple classes' do
      element.remove_class 'test', 'help'
      subject.should eq nil
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
      subject.should eq nil
    end

    it 'should add class if the element does not have the given class' do
      element.toggle_class 'help'
      subject.should eq 'test help'
    end

    it 'should add class if the second argument is true' do
      element.toggle_class 'help', true
      subject.should eq 'test help'
    end

    it 'should remove class if the second argument if false' do
      element.toggle_class 'test', false
      subject.should eq nil
    end
  end
end
