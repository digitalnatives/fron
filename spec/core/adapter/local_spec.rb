require 'spec_helper'

describe Fron::Adapters::LocalAdapter do

  subject { described_class.new fields: [:name] }

  describe '#all' do
    it 'should call localStorage#all' do
      Fron::Storage::LocalStorage.should receive(:all).once
      expect { |b| subject.all(&b) }.to yield_control
    end

    it 'should run the block' do
      expect { |b| subject.all(&b) }.to yield_control
    end
  end

  describe '#get' do
    it 'should call localStorage#get' do
      Fron::Storage::LocalStorage.should receive(:get).once
      expect { |b| subject.get(0, &b) }.to yield_control
    end

    it 'should run the block' do
      expect { |b| subject.get(0, &b) }.to yield_control
    end
  end

  describe '#set' do
    it 'should call localStorage#set' do
      Fron::Storage::LocalStorage.should receive(:set).once
      expect { |b| subject.set(double(id: 0), { name: 'test' }, &b) }.to yield_with_args
    end

    it 'should run the block with nil if there are no errors' do
      expect { |b| subject.set(double(id: 0), { name: 'test' }, &b) }.to yield_with_args nil, name: 'test', id: 0
    end

    it 'should run the block with erros if ther are any' do
      expect { |b| subject.set(double(id: 0), { name: '' }, &b) }.to yield_with_args({ name: ["can't be blank"] }, {})
    end

    it "should add id if there isn't any" do
      result = subject.set(double(id: nil), name: '') {}
      result[:id].should_not be nil
    end
  end

  describe '#validate' do
    it 'should return errors for undefined fields' do
      subject.validate.should eq name: ["can't be blank"]
    end

    it 'should return errors for empty fields' do
      subject.validate(name: '').should eq name: ["can't be blank"]
    end
  end
end
