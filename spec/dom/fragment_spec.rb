require 'spec_helper'

describe DOM::Fragment do

  subject { described_class.new }

  describe '#initailize' do
    it 'should create a document fragment' do
      el = subject.instance_variable_get('@el')
      `#{el} instanceof DocumentFragment`.should be true
    end
  end
end
