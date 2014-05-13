require 'fron/core'
require 'fron/storage'

describe Fron::Adapters::RailsAdapter do

  subject do
    described_class.new({
      fields: [:name],
      endpoint: "test",
      resources: "users",
      resource: "user"
    })
  end

  let(:proc) { Proc.new {} }
  let(:request) { double :request }

  before do
    subject.instance_variable_set "@request", request
  end

  describe "#all" do
    it "should call GET request to resources url" do
      request.should receive(:url=).with "test/users.json"
      request.should receive(:get) do |&block|
        block.call double json: true
      end
      proc.should receive(:call)
      subject.all &proc
    end
  end

  describe "#get" do
    it "should call GET request to resource url" do
      request.should receive(:url=).with "test/users/0"
      request.should receive(:get) do |&block|
        block.call double json: true
      end
      proc.should receive(:call)
      subject.get '0', &proc
    end
  end

  describe "#set" do
    it "should call POST request for new record" do
      request.should receive(:url=).with "test/users.json"
      request.should receive(:post) do |&block|
        block.call double status: 201
      end
      proc.should receive(:call)
      subject.set nil, {}, &proc
    end

    it "should call PUT request for exsistsing record" do
      request.should receive(:url=).with "test/users/0"
      request.should receive(:put) do |&block|
        block.call double status: 201
      end
      proc.should receive(:call)
      subject.set 0, {}, &proc
    end

    it "should call block with error" do
      request.should receive(:url=).with "test/users/0"
      request.should receive(:put) do |&block|
        block.call double status: 422, json: 'error'
      end
      proc.should receive(:call).with 'error'
      subject.set 0, {}, &proc
    end
  end
end
