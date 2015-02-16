require 'spec_helper'

describe Fron::Request do
  subject { described_class.new 'url' }
  let(:request) {
    %x{
      return { readyState: 0,
      open: function(){this.opened = true},
      send: function(){this.sent = true}}
    }
  }
  let(:data) { Hash.new }

  before do
    subject.instance_variable_set('@request', request)
  end

  describe '#request' do
    it 'should raise if the rquest is already running' do
      allow(subject).to receive(:ready_state).and_return 1
      expect(proc { subject.request }).to raise_error
    end

    it 'should call #open on request' do
      subject.get
      expect(`#{request}.opened`).to be true
    end

    it 'should call #send on request' do
      subject.get
      expect(`#{request}.sent`).to be true
    end

    it 'should call #to_query_string on data if it is a GET' do
      expect(data).to receive(:to_query_string)
      expect(data).not_to receive(:to_json)
      subject.get data
    end

    it 'should call #to_json on data if it is a GET' do
      expect(data).not_to receive(:to_query_string)
      expect(data).to receive(:to_json)
      subject.post data
    end

    it 'should set @callback' do
      subject.get do end
      subject.instance_variable_get('@callback').should_not be nil
    end
  end

  describe '#get' do
    it 'should call #request with GET' do
      expect(subject).to receive(:request).once
      subject.get
    end
  end

  describe '#post' do
    it 'should call #request with POST' do
      expect(subject).to receive(:request).once
      subject.post
    end
  end

  describe '#put' do
    it 'should call #request with PUT' do
      expect(subject).to receive(:request).once
      subject.put
    end
  end
end
