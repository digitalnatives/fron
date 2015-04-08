require 'fron'

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

run Opal::Server.new { |s|
  s.append_path 'website'
  s.source_map = false
  s.main = 'application'
}
