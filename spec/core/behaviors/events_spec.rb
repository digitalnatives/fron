require 'spec_helper'

# Test class for testing events behavior
class BehaviorsTest < Fron::Component
  on :focus, 'button', :test
  on :click, :click
end

describe Fron::Behaviors::Events do
  let(:event) { `{ target: document.createElement('button') }` }

  subject { BehaviorsTest.new }

  it 'should create events' do
    subject.listeners[:focus].count.should eq 1
    subject.listeners[:click].count.should eq 1
  end

  it 'should call events' do
    subject.should receive(:test)
    subject.should receive(:click)
    subject.listeners[:focus][0].call event
    subject.listeners[:click][0].call event
  end
end
