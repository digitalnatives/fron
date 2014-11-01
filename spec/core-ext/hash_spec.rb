require 'spec_helper'

describe Hash do

  subject { { a: 'test', b: 'user' } }

  describe '#toQueryString' do
    it 'should return the hash in query string format' do
      subject.toQueryString.should eq 'a=test&b=user'
    end
  end

  describe '#toFormData' do
    it 'should return the hash in FormData format' do
      `#{subject.toFormData} instanceof FormData`.should be true
    end
  end
end
