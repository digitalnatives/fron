require 'spec_helper'
require 'fron/utils/drag'

describe Fron::Drag do
  let(:event)    { double(pageX: 0, pageY: 0, preventDefult: true, stop: true, target: true) }
  let(:base)     { DOM::Element.new 'div'   }
  let(:position) { double }

  subject        { described_class.new base }

  before do
    allow(subject).to receive(:request_animation_frame)
  end

  around(:each) do |example|
    EventMock.mock_events(&example)
  end

  describe 'Events' do
    it 'should call start on mousedown' do
      subject.should receive(:start)
      subject.base.trigger 'mousedown'
    end

    it 'should call pos when mouse moves' do
      subject.should receive(:pos)
      subject.should receive(:request_animation_frame) do |&block|
        subject.instance_variable_set('@mouse_is_down', false)
        block.call
      end
      subject.start event
      subject.body.trigger 'mousemove'
    end

    it 'should call up when mouse moves' do
      subject.should receive(:up)
      subject.start event
      subject.body.trigger 'mouseup'
    end
  end

  describe '#initialize' do
    it 'should set the body' do
      subject.body.should eq DOM::Document.body
    end

    it 'should add mousedown event listener to the base' do
      subject.base.listeners['mousedown'].length.should eq 1
    end
  end

  describe '#diff' do
    it 'should diff start position and current position' do
      subject.instance_variable_set('@start_position', position)
      position.should receive(:-)
      subject.diff
    end
  end

  describe '#start' do
    it 'should call request_animation_frame' do
      subject.should receive(:request_animation_frame).once
      subject.start event
    end

    it 'should remove events if the dragging not finished properly' do
      subject.instance_variable_set('@pos_method', true)
      subject.should receive(:off)
      subject.start event
    end
  end

  describe '#pos' do
    it 'it should set position' do
      event.should receive(:stop)
      position.should receive(:distance).and_return 0
      subject.should receive(:diff).and_return position
      subject.should receive(:position).and_return position
      subject.pos event
      pos = subject.instance_variable_get('@position')
      pos.should eq position
    end
  end

  describe '#up' do
    it 'should stop dragging and reset things' do
      event.should receive(:stop)
      event.should receive(:preventDefault)
      subject.instance_variable_set('@started', true)
      subject.should receive(:reset)
      subject.should receive(:off)
      subject.should receive(:trigger).with 'end'
      subject.up event
    end
  end

  describe '#move' do
    it 'should call request_animation_frame if mouse is down' do
      subject.instance_variable_set('@mouse_is_down', true)
      subject.should receive(:request_animation_frame) do |&block|
        subject.instance_variable_set('@mouse_is_down', false)
        block.call
      end
      subject.move
    end

    it 'should trigger move if dragging' do
      subject.instance_variable_set('@started', true)
      subject.instance_variable_set('@position', position)
      subject.should receive(:trigger).with 'move', position
      subject.move
    end

    it 'should not trigger move if not dragging' do
      subject.should_not receive(:trigger)
      subject.should_not receive(:request_animation_frame)
      subject.move
    end
  end

  describe '#off' do
    it 'should remove events' do
      subject.body.should receive(:off).at_least(2).times
      subject.off
    end
  end

  describe '#position' do
    it 'should return the current position' do
      pos = subject.position event
      pos.should be_a Fron::Point
      pos.x.should eq 0
      pos.y.should eq 0
    end
  end
end
