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

  let(:registry) { subject.instance_variable_get('@registry') }

  it 'should inherit registry in order' do
    registry.should_not be nil
    registry[0][:args].should eq [:text, 'text']
    registry[2][:args].should eq [:title, 'title']
  end
end

describe InheritedComponent do
  subject { described_class }

  let(:registry) { subject.instance_variable_get('@registry') }

  it 'should inherit registry' do
    registry.should_not be nil
    registry[0][:args].should eq [:text, 'text']
    registry[1][:args].should eq [:click, :render]
  end
end
