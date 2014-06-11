require 'fron/core'

class TestModel < Fron::Model
end

class MockAdapter
  def all(&block)
    block.call [{},{}]
  end

  def get(&block)
    block.call({name: 'User'})
  end

  def set(model,data,&block)
    if model.id == 0
      block.call(nil, data)
    else
      block.call({errors: true}, {})
    end
  end
end

describe TestModel do

  subject { described_class }

  describe "DSL" do
    describe "#adapter" do
      it "should set adapter" do
        subject.adapter MockAdapter
        subject.adapterObject.should_not be nil
      end
    end

    describe "#field" do
      it "should set fields array" do
        subject.field :name
        subject.fields.should_not be nil
        subject.fields.should include(:name)
      end

      it "should define methods" do
        subject.field :description
        subject.instance_methods.should include(:description)
        subject.instance_methods.should include(:description=)
      end
    end
  end

  describe "Class Methods" do
    describe "#all" do
      it "should call adapter#call" do
        subject.adapterObject.should receive(:all)
        subject.all
      end

      it "should call new on self class for items" do
        subject.should receive(:new).twice
        subject.adapterObject.should receive(:all).and_call_original
        subject.all do end
      end
    end

    describe "#find" do
      it "should return class instance" do
        subject.adapterObject.should receive(:get).and_call_original
        subject.find do |instance|
          instance.class.should eq described_class
        end
      end

      it "should merge user data" do
        subject.adapterObject.should receive(:get).and_call_original
        subject.find do |instance|
          instance.name.should eq 'User'
        end
      end
    end
  end

  describe "Instance Methods" do
    subject { described_class.new({name: 'Test'}) }

    describe "#initialize" do
      it "should set data" do
        subject.name.should eq 'Test'
      end
    end

    describe "#update" do
      it "should call adapter#set" do
        described_class.adapterObject.should receive(:set).and_call_original
        subject.update
      end

      it "should merge user data" do
        described_class.adapterObject.should receive(:set).and_call_original
        subject.id = 0
        subject.update name: "User" do
          subject.errors.should be nil
          subject.name.should eq 'User'
        end
      end

      it "should set errors" do
        subject.id == 2
        subject.update do
          subject.errors.should_not be nil
        end
      end
    end

    describe "#dirty?" do
      it "should return true if there is no id" do
        subject.dirty?.should eq true
      end

      it "should return false if there is and id" do
        subject.id = 0
        subject.dirty?.should eq false
      end
    end
  end
end
