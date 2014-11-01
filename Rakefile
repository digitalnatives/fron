require 'quality_control'
require 'quality_control/all'
require 'fron'

QualityControl::Rubycritic.directories += %w(opal)
QualityControl::Rubycritic.rating_threshold = 'C'
QualityControl::Yard.threshold = 60
QualityControl::OpalRspec.files = /^opal\/fron\/.*\.rb/
QualityControl::OpalRspec.threshold = 85

QualityControl.tasks += %w(
  syntax:ruby
  opal:rspec:coverage
  documentation:coverage
  rubycritic:coverage
)
