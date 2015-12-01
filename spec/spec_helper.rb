require 'rspec_coverage_helper'
require 'js/mocks'
require 'fron'
require 'fron/event_mock'

::RSpec.configure do |c|
  c.after(:each) do
    DOM::Document.body.off
    DOM::Window.off
  end
end
