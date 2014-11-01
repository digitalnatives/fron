require 'spec_helper'

describe Fron::Response do

  let(:headers) { 'Content-Type: application/json' }
  let(:status)  { 200 }
  let(:body)    { '<div></div>' }
  subject       { described_class.new status, body, headers }

  describe '#json' do
    let(:body) { { key: 'value' }.to_json }

    it 'should return the json body as a hash' do
      subject.json.class.should eq Hash
      subject.json[:key].should eq 'value'
    end
  end

  describe '#ok?' do
    context '200' do
      it 'should return true if status is 200' do
        subject.ok?.should be true
      end
    end

    context '404' do
      let(:status) { 404 }
      it 'should return false if status is not 200' do
        subject.ok?.should be false
      end
    end
  end

  describe '#dom' do
    it 'should return with a Fragment' do
      subject.dom.class.should eq DOM::Fragment
      subject.dom.children[0].should_not be nil
    end
  end

  describe '#contentType' do
    it 'should return content type' do
      subject.contentType.should eq 'application/json'
    end
  end
end
