require 'bundler'
Bundler.require
Bundler::GemHelper.install_tasks
require 'opal/rspec/rake_task'
require 'rack'

Opal::RSpec::RakeTask.new(:default)

task :test do

	app = Opal::Server.new { |s|
    s.main = 'opal/rspec/sprockets_runner'
    s.append_path 'spec'
    s.debug = false
  }

  Rack::Server.start(:app => app, :Port => 9292)
end
