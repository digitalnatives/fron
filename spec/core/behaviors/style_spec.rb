require 'spec_helper'

# Test Component
class StyleTest < Fron::Component
  tag 'style-test'

  stylesheet 'http://test.com/index.css'

  style background: :red,
        img: {
          width: 200.px
        },
        '&:hover' => {
          color: :blue
        }
end

describe StyleTest do
  let(:style) { DOM::Document.head.find('style') }

  before do
    subject
  end

  it 'should create style tag' do
    style.should_not be_nil
  end

  it 'should set css for component' do
    style.text.should match('style-test')
  end

  it 'should set css for sub rulest' do
    style.text.should match('style-test img')
  end

  it 'should set css for hover' do
    style.text.should match('style-test:hover')
  end

  it 'should create styleheet link tag' do
    DOM::Document.head.find('link[href*="test.com"]').should_not be_nil
  end
end
