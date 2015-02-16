require 'spec_helper'

describe DOM::Style do
  subject { DOM::Element.new 'div' }
  let(:el) { subject.instance_variable_get('@el') }

  describe 'method_missing' do
    it 'should call []= if the methods ends with =' do
      expect(subject.style).to receive(:[]=).with 'display', 'none'
      subject.style.display = 'none'
    end

    it 'should call [] if the method does not end with =' do
      expect(subject.style).to receive(:[]).with 'display'
      subject.style.display
    end
  end

  describe '[]=' do
    it 'should set the given style' do
      subject.style['display'] = 'none'
      `#{el}.style.display`.should eq 'none'
    end
  end

  describe '[]"'do
    it 'should return with the value of the given style' do
      `#{el}.style.display = 'block'`
      subject.style['display'].should eq 'block'
    end
  end
end
