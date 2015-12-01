require 'spec_helper'

describe DOM::Dimensions do
  subject { DOM::Element.new 'div' }

  before do
    subject >> DOM::Document.body
    subject.style.position = 'absolute'
    subject.style.width = '100px'
    subject.style.top = '40px'
    subject.style.left = '60px'
    subject.style.height = '80px'
  end

  after do
    subject.remove!
  end

  describe '#scroll_top' do
    it 'should return the scroll position' do
      subject.scroll_top.should eq 0
    end
  end

  describe '#scroll_left' do
    it 'should return the scroll position' do
      subject.scroll_left.should eq 0
    end
  end

  describe '#cover?' do
    let(:pos) { double x: 62, y: 82 }
    it 'should return the true if it covers' do
      subject.cover?(pos).should eq true
    end
  end

  describe '#top' do
    it 'should return the top position' do
      subject.top.should eq 40
    end
  end

  describe '#left' do
    it 'should return the left position' do
      subject.left.should eq 60
    end
  end

  describe '#right' do
    it 'should return the right position' do
      subject.right.should eq 160
    end
  end

  describe '#bottom' do
    it 'should return the bottom position' do
      subject.bottom.should eq 120
    end
  end

  describe '#width' do
    it 'should return the width' do
      subject.width.should eq 100
    end
  end

  describe '#height' do
    it 'should return the height' do
      subject.height.should eq 80
    end
  end

  describe '#visible?' do
    context 'display: none' do
      it 'should return false' do
        expect {
          subject.style.display = 'none'
        }.to change { subject.visible? }.from(true).to(false)
      end
    end

    context 'not in viewport' do
      height = `window.innerHeight`
      width = `window.innerWidth`
      [
        [-80, -100],     # Top Left
        [-80, 0],        # Top
        [0, -100],       # Left
        [height, width], # Bottom Right
        [height, 0],     # Bottom
        [0, width]       # Right
      ].each do |item|
        it "should return false for #{item}" do
          top, left = item
          expect {
            subject.style.top = "#{top}px"
            subject.style.left = "#{left}px"
          }.to change { subject.visible? }.from(true).to(false)
        end
      end
    end

    context '0 size' do
      it 'should return false' do
        expect {
          subject.style.width = 0
          subject.style.height = 0
        }.to change { subject.visible? }.from(true).to(false)
      end
    end

    context 'not in dom' do
      it 'should return false' do
        expect {
          subject.remove!
        }.to change { subject.visible? }.from(true).to(false)
      end
    end
  end
end
