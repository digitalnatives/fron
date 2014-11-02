require 'spec_helper'

describe DOM::Event do

  subject { described_class.new data }
  let(:target) { DOM::Element.new('div') }

  let(:data) {
    %x{
      return {
        charCode: 1,
        keyCode: 2,
        pageX: 3,
        pageY: 4,
        screenX: 5,
        screenY: 6,
        clientX: 7,
        clientY: 8,
        altKey: true,
        shiftKey: false,
        ctrlKey: true,
        metaKey: false,
        preventDefault: function(){return 1},
        stopPropagation: function(){return 2},
        stopImmediatePropagation: function(){},
        target: #{target.instance_variable_get('@el')}
      }
    }
  }

  describe '#stop' do
    it 'should call stopPropagation and preventDefault' do
      expect(subject).to receive(:stopPropagation).once
      expect(subject).to receive(:preventDefault).once
      subject.stop
    end
  end

  describe '#stopPropagation' do
    it 'should call stopPropagation of the event' do
      subject.stopPropagation.should eq 2
    end
  end

  describe '#preventDefault' do
    it 'should call preventDefault of the event' do
      subject.preventDefault.should eq 1
    end
  end

  describe '#target' do
    it 'should return the target' do
      subject.target.should equal target
    end
  end

  describe '#charCode' do
    it 'should return the charCode' do
      subject.charCode.should eq 1
    end
  end

  describe '#keyCode' do
    it 'should return the keyCode' do
      subject.keyCode.should eq 2
    end
  end

  describe '#pageX' do
    it 'should return the pageX' do
      subject.pageX.should eq 3
    end
  end

  describe '#pageY' do
    it 'should return the pageY' do
      subject.pageY.should eq 4
    end
  end

  describe '#screenX' do
    it 'should return the screenX' do
      subject.screenX.should eq 5
    end
  end

  describe '#screenY' do
    it 'should return the screenY' do
      subject.screenY.should eq 6
    end
  end

  describe '#clientX' do
    it 'should return the clientX' do
      subject.clientX.should eq 7
    end
  end

  describe '#clientY' do
    it 'should return the clientY' do
      subject.clientY.should eq 8
    end
  end

  describe '#alt' do
    it 'should return the alt?' do
      subject.alt?.should eq true
    end
  end

  describe '#shift' do
    it 'should return the shift?' do
      subject.shift?.should eq false
    end
  end

  describe '#ctrl' do
    it 'should return the ctrl?' do
      subject.ctrl?.should eq true
    end
  end

  describe '#meta' do
    it 'should return the meta?' do
      subject.meta?.should eq false
    end
  end
end
