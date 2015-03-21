require 'rubygems'
require 'bundler/setup'
require 'quality_control'
require 'quality_control/rubycritic'
require 'quality_control/rubocop'
require 'quality_control/yard'
require 'quality_control/opal_rspec'
require 'fron'

Bundler::GemHelper.install_tasks

QualityControl::Rubycritic.directories += %w(opal)
QualityControl::Yard.threshold = 95
QualityControl::OpalRspec.files = /^opal\/fron\/.*\.rb/
QualityControl::OpalRspec.threshold = 98

QualityControl.tasks += %w(
  syntax:ruby
  opal:rspec:coverage
  documentation:coverage
  rubycritic:coverage
)
