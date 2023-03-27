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

  s.required_ruby_version = '>= 2.7.0', '<4.0.0'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  # Testing dependencies
  s.add_development_dependency 'fakefs', '>= 0.6', '< 2'
  s.add_development_dependency 'minitest', '~> 5.4'
  s.add_development_dependency 'rake', '~> 13.0'

  # rubocop
  s.add_development_dependency 'rubocop', '~> 1.48.1'
  s.add_development_dependency 'rubocop-minitest'
  s.add_development_dependency 'rubocop-performance'
  s.add_development_dependency 'rubocop-rake'
  s.add_development_dependency 'rubocop-rspec'

  # Documentation dependencies
  s.add_development_dependency 'thin'
  s.add_development_dependency 'yard'

  # Run time dependencies
  s.add_runtime_dependency 'beaker', '> 3.0'
  s.add_runtime_dependency 'rspec', '~> 3.0'
  s.add_runtime_dependency 'serverspec', '~> 2'
  s.add_runtime_dependency 'specinfra', '~> 2'
end
