require 'spec_helper'

describe DOM::Dimensions do

  let(:element) { DOM::Element.new 'div' }

  before do
    element >> DOM::Document.body
    element.style.position = 'absolute'
    element.style.width = '100px'
    element.style.top = '40px'
    element.style.left = '60px'
    element.style.height = '80px'
  end

  after do
    element.remove!
  end

  describe '#top' do
    it 'should return the top position of the element' do
      element.top.should eq 40
    end
  end

  describe '#left' do
    it 'should return the left position of the element' do
      element.left.should eq 60
    end
  end

  describe '#right' do
    it 'should return the right position of the element' do
      element.right.should eq 160
    end
  end

  describe '#bottom' do
    it 'should return the bottom position of the element' do
      element.bottom.should eq 120
    end
  end

  describe '#width' do
    it 'should return the width of the element' do
      element.width.should eq 100
    end
  end

  describe '#height' do
    it 'should return the height of the element' do
      element.height.should eq 80
    end
  end
end
