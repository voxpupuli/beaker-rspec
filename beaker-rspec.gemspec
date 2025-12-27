# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)
require 'beaker-rspec/version'

Gem::Specification.new do |s|
  s.name        = 'beaker-rspec'
  s.version     = BeakerRSpec::Version::STRING
  s.authors     = ['Vox Pupuli']
  s.email       = ['voxpupuli@groups.io']
  s.homepage    = 'https://github.com/voxpupuli/beaker-rspec'
  s.summary     = 'RSpec bindings for beaker'
  s.description = 'RSpec bindings for beaker, see https://github.com/voxpupuli/beaker'
  s.license     = 'Apache-2.0'

  s.required_ruby_version = '>= 3.2.0', '<4.0.0'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  # Testing dependencies
  s.add_development_dependency 'fakefs', '>= 0.6', '< 4'
  s.add_development_dependency 'minitest', '~> 5.4'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'voxpupuli-rubocop', '~> 5.1.0'

  # Run time dependencies
  s.add_dependency 'beaker', '>= 4.0', '< 8'
  s.add_dependency 'rspec', '~> 3.0'
  s.add_dependency 'serverspec', '~> 2'
  s.add_dependency 'specinfra', '~> 2'
end
