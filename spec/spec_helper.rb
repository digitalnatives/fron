require 'rspec_coverage_helper'
require 'fron'

::RSpec.configure do |c|
  c.after(:each) do
    DOM::Document.body.off
    DOM::Window.off
  end
end
