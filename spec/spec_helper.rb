require 'rspec_coverage_helper'
require 'fron'

%x{
  window.requestAnimationFrame = function(callback){ callback() }
  window.setTimeout = function(callback) { callback() }
  window.clearTimeout = function() { return true }
  window.alert = function(text) { return 'alert' }
  window.confirm = function(text) { return true }
  window.prompt = function(text, value) { return value }
}

::RSpec.configure do |c|
  c.after(:each) do
    DOM::Document.body.off
    DOM::Window.off
  end
end
