require 'spec_helper'

describe String do
  subject { 'asd_asd-asd' }

  describe '#camelize' do
    it 'should camelize the string' do
      subject.camelize.should eq 'asdAsdAsd'
    end
  end
end
