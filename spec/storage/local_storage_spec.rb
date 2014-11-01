require 'spec_helper'

describe Fron::Storage::LocalStorage do

  subject { described_class }

  before do
    subject.clear
    subject.set 'key', data: 'value'
  end

  describe '#get' do
    it 'should get the data for the key' do
      data = subject.get('key')
      data.class.should eq Hash
      data[:data].should eq 'value'
    end
  end

  describe '#set' do
    it 'should set data for the key' do
      subject.set 'key2', data: 'value'
      subject.keys.include?('key2').should be true
      subject.all.length.should be 2
    end
  end

  describe '#keys' do
    it 'should return all the keys' do
      subject.keys.include?('key').should be true
      subject.all.length.should eq 1
    end
  end

  describe '#remove' do
    it 'should remove the key' do
      subject.all.length.should eq 1
      subject.remove 'key'
      subject.all.length.should eq 0
    end
  end

  describe '#all' do
    it 'should get the data for all key' do
      data = subject.all[0]
      data.class.should eq Hash
      data[:data].should eq 'value'
    end
  end

  describe '#clear' do
    it 'should remove all keys' do
      subject.all.length.should eq 1
      subject.clear
      subject.all.length.should eq 0
    end
  end
end
