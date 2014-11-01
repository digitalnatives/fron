require 'spec_helper'

# Test Application
class TestApplication < Fron::Application
  config.title = 'Test Application'
  config.logger.level = :error
end

describe Fron::Application do

  subject { TestApplication.new }

  after do
    subject.config.app.remove!
  end

  describe '#initialize' do
    it 'should insert the application into the DOM' do
      subject.config.app.parent.should_not be nil
    end

    it 'should set the title of the document' do
      DOM::Document.title.should eq 'Test Application'
    end
  end

  describe '#loadExternalStylesheets' do
    it 'should load external stylesheets' do
      subject.config.stylesheets = ['test']
      subject.send(:loadExternalStylesheets)
      link = DOM::Document.head.find('link')
      link['href'].should be 'test'
      link.remove!
    end
  end
end
