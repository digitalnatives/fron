require 'spec_helper'

describe DOM::Window do
  subject { described_class }

  describe '#state' do
    it 'should return the pathname' do
      subject.state.should eq '/'
    end
  end

  describe '#state=' do
    it 'should set the state' do
      subject.should receive(:trigger).with 'popstate'
      subject.state = '/test'
      subject.state.should eq '/test'
    end
  end

  describe '#hash' do
    it 'should return the hash of the url' do
      `window.location.hash = 'test'`
      subject.hash.should eq 'test'
    end
  end

  describe '#hash=' do
    it 'should set the hash of the url' do
      subject.hash = 'test2'
      `window.location.hash.slice(1)`.should eq 'test2'
    end
  end

  describe 'scrollY' do
    it 'should return the vertical scroll position' do
      subject.scroll_y.should eq 0
    end
  end

  describe 'scrollX' do
    it 'should return the horizontal scroll position' do
      subject.scroll_x.should eq 0
    end
  end
end
