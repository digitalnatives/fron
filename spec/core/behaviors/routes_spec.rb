require 'spec_helper'

# Failing Test Component
class FailRouteComponent < Fron::Component
  include Fron::Behaviors::Routes

  route 'something', :something
end

# Failing Test Component
class RouteComponent < Fron::Component
  attr_reader :id

  include Fron::Behaviors::Routes

  route 'something', :something
  route(/cards\/(.*)/, :card)

  def something
  end

  def card
  end
end

describe FailRouteComponent do
  it 'should rasie error on initialize' do
    expect { subject }.to raise_error
  end
end

describe RouteComponent do
  before do
    Fron::Behaviors::Routes.instance_variable_set('@routes', [])
  end

  context 'Events' do
    it 'should call handle_hash_change' do
      Fron::Behaviors::Routes.listen
      Fron::Behaviors::Routes.should receive(:handle_hash_change)
      DOM::Window.listeners[:popstate].count.should eq 1
      DOM::Window.listeners[:popstate][0].call
    end
  end

  context 'Matching hash' do
    it 'should call the method' do
      subject.should receive(:something)
      Fron::Behaviors::Routes.handle_hash_change('something')
    end
  end

  context 'Parameters' do
    it 'should call the method with matches' do
      subject.should receive(:card).with 'id'
      Fron::Behaviors::Routes.handle_hash_change('cards/id')
    end
  end
end
