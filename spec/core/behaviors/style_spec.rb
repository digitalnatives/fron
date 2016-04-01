require 'spec_helper'

# Test Component
class StyleTest < Fron::Component
  tag 'style-test'

  stylesheet 'http://test.com/index.css'

  keyframes 'test', from: { color: :red },
                    to: { color: :blue }

  style background: :red,
        img: {
          width: 200.px
        },
        '&:hover' => {
          color: :blue
        }
end

describe StyleTest do
  let(:style) { Fron::Sheet.render }

  before do
    subject
  end

  it 'should create style tag' do
    style.should_not be_nil
  end

  it 'should set css for component' do
    style.should match('style-test')
  end

  it 'should set css for sub rulest' do
    style.should match('style-test img')
  end

  it 'should set css for hover' do
    style.should match('style-test:hover')
  end

  it 'should create keyframes rule' do
    style.should match('@keyframes test')
  end

  it 'should create styleheet link tag' do
    style.should match('test.com')
  end
end
