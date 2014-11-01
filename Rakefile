require 'quality_control'
require 'quality_control/all'
require 'fron'

QualityControl::Rubycritic.directories += %w(opal)
QualityControl::Yard.threshold = 90
QualityControl::OpalRspec.files = %r{^opal/fron/.*\.rb/}
QualityControl::OpalRspec.threshold = 85

QualityControl.tasks += %w(
  syntax:ruby
  opal:rspec:coverage
  documentation:coverage
  rubycritic:coverage
)

require 'rack'
task :test do

  app = Opal::Server.new { |s|
    s.main = 'opal/rspec/sprockets_runner'
    s.append_path 'spec'
    s.debug = false
  }

  Rack::Server.start(:app => app, :Port => 9292)
end
