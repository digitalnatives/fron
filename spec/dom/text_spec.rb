require 'spec_helper'

describe DOM::Text do

  subject { described_class.new('test') }
  let(:el) { subject.instance_variable_get('@el') }

  describe '#initailize' do
    it 'should create textNode with given value' do
      subject.text.should eq 'test'
      `#{el} instanceof Text`.should be true
    end
  end
end
