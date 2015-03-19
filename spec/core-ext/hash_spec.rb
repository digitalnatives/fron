require 'spec_helper'

describe Hash do
  let(:base)  { { a: 'test', b: 'asd', c: { test: 'asd' } } }
  let(:other) { { a: 'test', b: 'user', c: { test: 'wtf' } } }
  let(:diff)  { { b: %w(asd user), c: { test: %w(asd wtf) } } }

  subject { { a: 'test', b: 'user' } }

  describe '#to_query_string' do
    it 'should return the hash in query string format' do
      subject.to_query_string.should eq 'a=test&b=user'
    end
  end

  describe '#to_form_data' do
    it 'should return the hash in FormData format' do
      `#{subject.to_form_data} instanceof FormData`.should be true
    end
  end

  describe '#deep_diff' do
    it 'should return a diff of the two objects' do
      base.deep_diff(other).should eq diff
    end
  end
end
