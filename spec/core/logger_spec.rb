require 'spec_helper'

describe Fron::Logger do

  subject { described_class.new }

  before do
    allow(subject).to receive(:puts)
  end

  describe '#initialize' do
    it 'should set log level to :info' do
      subject.level.should eq :info
    end
  end

  describe '#info' do
    it 'should add timestamp to message' do
      expect(Time).to receive(:now).and_call_original
      subject.info 'test'
    end

    it 'should call puts' do
      expect(subject).to receive(:puts).once
      subject.info 'test'
    end
  end
end
