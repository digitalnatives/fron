require 'rubygems'
require 'opal/rspec/rake_task'
require 'bundler/setup'
require 'fron'

Opal::RSpec::RakeTask.new(:spec) do |_, task|
  task.files = FileList[ARGV[1] || 'spec/**/*_spec.rb']
  task.timeout = 120_000
end

desc 'Run CI Tasks'
task :ci do
  sh 'SPEC_OPTS="--color" rake spec'
  sh 'rubocop lib opal spec'
  sh 'rubycritic lib opal --mode-ci -s 94 --no-browser'
end
