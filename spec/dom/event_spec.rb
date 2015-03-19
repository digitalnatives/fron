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
        button: 3,
        altKey: true,
        shiftKey: false,
        ctrlKey: true,
        metaKey: false,
        dataTransfer: [],
        missing: 'missing',
        defaultPrevented: true,
        preventDefault: function(){return 1},
        stopPropagation: function(){return 2},
        stopImmediatePropagation: function(){ return 3 },
        target: #{target.instance_variable_get('@el')}
      }
    }
  }

  describe '#stop' do
    it 'should call stop_propagation and prevent_default' do
      expect(subject).to receive(:stop_propagation).once
      expect(subject).to receive(:prevent_default).once
      expect(subject).to receive(:stop_immediate_propagation).once
      subject.stop
    end
  end

  describe '#data_transfer' do
    it 'should return data_transfer' do
      subject.data_transfer.should be_an Array
    end
  end

  describe '#button' do
    it 'should return button' do
      subject.button.should eq 3
    end
  end

  describe '#default_prevented?' do
    it 'should return default_prevented?' do
      subject.default_prevented?.should eq true
    end
  end

  describe '#stop_immediate_propagation' do
    it 'should call stop_immediate_propagation of the event' do
      subject.stop_immediate_propagation.should eq 3
    end
  end

  describe '#method_missing' do
    it 'should return the given attribute of the event' do
      subject.missing.should eq 'missing'
    end
  end

  describe '#stop_propagation' do
    it 'should call stop_propagation of the event' do
      subject.stop_propagation.should eq 2
    end
  end

  describe '#prevent_default' do
    it 'should call prevent_default of the event' do
      subject.prevent_default.should eq 1
    end
  end

  describe '#target' do
    it 'should return the target' do
      subject.target.should equal target
    end
  end

  describe '#char_code' do
    it 'should return the char_code' do
      subject.char_code.should eq 1
    end
  end

  describe '#key_code' do
    it 'should return the key_code' do
      subject.key_code.should eq 2
    end
  end

  describe '#page_x' do
    it 'should return the page_x' do
      subject.page_x.should eq 3
    end
  end

  describe '#page_y' do
    it 'should return the page_y' do
      subject.page_y.should eq 4
    end
  end

  describe '#screen_x' do
    it 'should return the screen_x' do
      subject.screen_x.should eq 5
    end
  end

  describe '#screen_y' do
    it 'should return the screen_y' do
      subject.screen_y.should eq 6
    end
  end

  describe '#client_x' do
    it 'should return the client_x' do
      subject.client_x.should eq 7
    end
  end

  describe '#client_y' do
    it 'should return the client_y' do
      subject.client_y.should eq 8
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
