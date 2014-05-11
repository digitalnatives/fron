# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fron/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'fron'
  s.version      = Fron::VERSION
  s.author       = 'Gusztav Szikszai'
  s.email        = 'gusztav.szikszai@digitalnatives.hu'
  s.homepage     = ''
  s.summary      = 'Frontend Application Framework'
  s.description  = 'Frontend Application Framework that uses Opal'

  s.files          = `git ls-files`.split("\n")
  s.executables    = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_runtime_dependency 'opal', ['~> 0.6.2']
  s.add_development_dependency 'opal-rspec', '~> 0.3.0.beta3'
end
