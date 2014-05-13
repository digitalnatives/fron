require 'fron/storage'
require 'fron/core'

describe Fron::Adapters::LocalAdapter do

  subject { described_class.new({fields: [:name]}) }
  let(:proc) { Proc.new {} }

  describe "#all" do
    it "should call localStorage#all" do
      Fron::Storage::LocalStorage.should receive(:all).once
      subject.all &proc
    end

    it "should run the block" do
      proc.should receive(:call)
      subject.all &proc
    end
  end

  describe "#get" do
    it "should call localStorage#get" do
      Fron::Storage::LocalStorage.should receive(:get).once
      subject.get 0, &proc
    end

    it "should run the block" do
      proc.should receive(:call)
      subject.get 0, &proc
    end
  end

  describe "#set" do
    it "should call localStorage#set" do
      Fron::Storage::LocalStorage.should receive(:set).once
      subject.set 0, {name: 'test'}, &proc
    end

    it "should run the block with nil if there are no errors" do
      proc.should receive(:call).with nil
      subject.set 0, {name: 'test'}, &proc
    end

    it "should run the block with erros if ther are any" do
      proc.should receive(:call).with({name: ["can't be blank"]})
      subject.set 0, {name: ''}, &proc
    end

    it "should add id if there isn't any" do
      result = subject.set nil, {name: ''}, &proc
      result[:id].should_not be nil
    end
  end

  describe "#validate" do
    it "should return errors for undefined fields" do
      subject.validate.should eq({name: ["can't be blank"]})
    end

    it "should return errors for empty fields" do
      subject.validate({name: ''}).should eq({name: ["can't be blank"]})
    end
  end
end

