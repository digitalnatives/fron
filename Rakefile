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

task :build do
  require 'sprockets'
  require 'opal'
  require 'execjs'

  environment = Sprockets::Environment.new

  Opal.paths.each do |path|
    environment.append_path path
  end

  environment.append_path 'website'

  source = environment['setup'].to_s

  script = Opal::Sprockets.javascript_include_tag('setup', sprockets: environment, prefix: '/assets', debug: false)

  code = script.split("\n")
               .last
               .gsub('<script>', '')
               .gsub('</script>', '')

  head = """
    document = {}
    window = {}
    Node = {}
    try {
      #{source}
    } catch(e) {
      throw(e.stack)
    }
  """
  context = ExecJS.compile (head)
  puts context.exec(code + "; return Opal.Fron.Sheet.$render()")
end
