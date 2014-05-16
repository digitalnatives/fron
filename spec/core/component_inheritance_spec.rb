require 'fron/core'

class BaseComponent < Fron::Component
  component :text, 'text'
  on :click, :render
  delegate :text, :text
end

class InheritedComponent < BaseComponent
  component :title, 'title'
end

class SuperComponent < InheritedComponent
end

describe SuperComponent do
  subject { described_class }

  it "should inherit components in order" do
    subject.components.should_not be nil
    subject.components[0].should eq [:text,'text',nil]
    subject.components[1].should eq [:title,'title',nil]
  end
end

describe InheritedComponent do
  subject { described_class }

  it "should inherit components" do
    subject.components.should_not be nil
    subject.components[0].should eq [:text,'text',nil]
  end

  it "should inherit events" do
    subject.events.should_not be nil
    subject.events[0].should eq [:click, :render]
  end

  it "should inherit delegates" do
    subject.delegates.should_not be nil
    subject.delegates[0].should eq [:text,:text]
  end
end
