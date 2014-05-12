require 'fron/core-ext/hash'

describe Hash do

  subject { { a: 'test', b: 'user' } }

  describe "#to_query_string" do
    it 'should return the hash in query string format' do
      subject.to_query_string.should eq 'a=test&b=user'
    end
  end

  describe '#to_form_data' do
    it 'should return the hash in FormData format' do
      `#{subject.to_form_data} instanceof FormData`.should be true
    end
  end
end
