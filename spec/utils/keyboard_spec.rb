require 'spec_helper'
require 'fron/utils/keyboard'

# Test Keyboard Class
class TestKeyboard < Fron::Keyboard
  sc 'ctrl+up'
end

describe TestKeyboard do

  describe Fron::Keyboard do
    it 'should work on its own' do
      Fron::Keyboard.new.should be_a Fron::Keyboard
    end
  end

  describe 'DSL' do

    subject { described_class }

    describe '#sc' do
      it 'should define a shortcut with action' do
        subject.sc 'ctrl+down', :test
        subject.shortcuts.last.should eq(
          parts: %w(ctrl down),
          action: :test,
          block: nil
        )
      end

      it 'should define a shortcut with block' do
        sc = subject.shortcuts.first
        sc[:parts].should eq %w(ctrl up)
        sc[:action].should eq nil
      end
    end
  end

  describe 'Events' do
    it 'should handle keydown' do
      subject.should receive(:onKeydown)
      DOM::Document.body.trigger 'keydown'
    end
  end

  describe '#onKeydown' do

    let(:event) { DOM::Event.new `{ctrlKey: true, altKey: true, shiftKey: true, keyCode: 38}` }
    let(:shortcut) { { parts: %w(ctrl alt shift up) } }

    it 'should match shortcuts to the combo' do
      described_class.instance_variable_set('@shortcuts', [{ parts: [] }, shortcut])
      subject.should receive(:handleShortcut).with shortcut
      event.should receive(:stop)
      subject.onKeydown event
    end
  end

  describe 'handleShortcut' do
    it 'should run block if block given' do
      sc = { block: proc {} }
      subject.should receive(:instance_exec)
      subject.handleShortcut sc
    end

    it 'should call action method if given' do
      subject.should receive(:test)
      subject.handleShortcut action: :test
    end

    it 'should warn if method is not exists' do
      subject.should receive(:warn)
      subject.handleShortcut action: :test2, parts: %w(a b)
    end
  end
end
