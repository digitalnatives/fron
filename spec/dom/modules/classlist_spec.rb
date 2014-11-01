require 'spec_helper'

describe DOM::ClassList do

  let(:element) { DOM::Element.new 'div' }
  subject { element['class'] }

  describe '#addClass' do
    it 'should add a class' do
      element.addClass 'test'
      subject.should eq 'test'
    end

    it 'should add multiple classes' do
      element.addClass 'test', 'help'
      subject.should eq 'test help'
    end
  end

  describe '#removeClass' do
    before do
      element['class'] = 'test help'
    end

    it 'should add a class' do
      element.removeClass 'test'
      subject.should eq 'help'
    end

    it 'should add multiple classes' do
      element.removeClass 'test', 'help'
      subject.should eq ''
    end
  end

  describe '#hasClass' do
    it 'should return true if the element has given class' do
      element['class'] = 'test'
      element.hasClass('test').should eq true
    end

    it 'should return flase if the element does not have the given class' do
      element.hasClass('test').should eq false
    end
  end

  describe '#toggleClass' do
    before do
      element['class'] = 'test'
    end

    it 'should remove class if the element has the given class' do
      element.toggleClass 'test'
      subject.should eq ''
    end

    it 'should add class if the element does not have the given class' do
      element.toggleClass 'help'
      subject.should eq 'test help'
    end

    it 'should add class if the second argument is true' do
      element.toggleClass 'help', true
      subject.should eq 'test help'
    end

    it 'should remove class if the second argument if false' do
      element.toggleClass 'test', false
      subject.should eq ''
    end
  end
end
