require 'fron'
require 'active_support/core_ext/string/inflections'

# Proxy
class Proxy
  def initialize(app)
    @app = app
  end

  def call(env)
    env['PATH_INFO'] = '/' if !(env['PATH_INFO'] =~ /\..*$/) && !(env['PATH_INFO'] =~ /^\/(pages)/)
    @app.call env
  end
end

use Proxy

module Helpers
  def example(klass)
    source = File.read(File.join(File.dirname(__FILE__),"examples/#{klass.underscore}.rb"))
    "<example class='#{klass}'></example>\n```ruby\n#{source}\n```"
  end
end

run Opal::Server.new { |s|
  s.append_path 'website'
  s.source_map = false
  s.main = 'application'
  s.sprockets.context_class.send(:include, Helpers)
}
