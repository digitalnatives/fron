require 'spec_helper'

# Bevahviors
module Dummy
  def self.included(base)
    base.register self, [:dummy]
  end
end

# Base Component
class BaseComponent < Fron::Component
  component :text, 'text'
  on :click, :render

  include Dummy
end

# Inherited Component
class InheritedComponent < BaseComponent
  component :title, 'title'
end

class SuperComponent < InheritedComponent
end

describe SuperComponent do
  subject { described_class }

  let(:components) { subject.instance_variable_get('@component') }

  it 'should inherit components in order' do
    components.should_not be nil
    components[0].should eq [:text, 'text', nil]
    components[1].should eq [:title, 'title', nil]
  end
end

describe InheritedComponent do
  subject { described_class }

  let(:components) { subject.instance_variable_get('@component') }
  let(:events) { subject.instance_variable_get('@on') }

  it 'should inherit components' do
    components.should_not be nil
    components[0].should eq [:text, 'text', nil]
  end

  it 'should inherit events' do
    events.should_not be nil
    events[0].should eq [:click, :render, nil]
  end
end
