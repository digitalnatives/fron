require 'spec_helper'

describe Kernel do
  describe '#request_animation_frame' do
    it 'should return nil if no block given' do
      request_animation_frame.should eq nil
    end

    it 'should run the block inside requestAnimationFrame' do
      value = nil
      request_animation_frame do
        value = true
      end
      value.should eq true
    end
  end

  describe '#timeout' do
    it 'should run the provided block' do
      value = nil
      timeout do
        value = true
      end
      value.should eq true
    end
  end

  describe '#prompt' do
    it 'should show the window' do
      prompt('test', 'value').should eq 'value'
    end
  end

  describe '#alert' do
    it 'should show the window' do
      alert('test').should eq 'alert'
    end
  end

  describe '#confirm' do
    it 'should show the window' do
      confirm('test').should eq true
    end
  end

  describe '#clear_timeout' do
    it 'should clear the timeout' do
      clear_timeout(0).should eq true
    end
  end

  describe '#logger' do
    it 'should return logger' do
      logger.should be_a Fron::Logger
    end
  end
end
