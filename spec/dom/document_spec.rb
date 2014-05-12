require 'fron/dom'

describe DOM::Document do

  subject { DOM::Document }

  describe "head" do
    it 'should return the head element' do
      DOM::Element.new(`document.head`).should eq subject.head
    end
  end

  describe "body" do
    it 'should return the body element' do
      DOM::Element.new(`document.body`).should eq subject.body
    end
  end

  describe 'title' do
    it 'should return the title of the document' do
      subject.title.should eq "Opal Server"
    end
  end

  describe 'title=' do
    it 'should set the title of the document' do
      subject.title = 'test'
      `document.title`.should eq 'test'
    end
  end

  describe 'find' do
    it 'should return nil if no element is found' do
      subject.find('list').should eq nil
    end

    it 'should return element' do
      subject.find('body').class.should eq DOM::Element
    end
  end
end
