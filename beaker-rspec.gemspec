# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'beaker-rspec/version'

Gem::Specification.new do |s|
  s.name        = "beaker-rspec"
  s.version     = BeakerRSpec::Version::STRING
  s.authors     = ["Puppetlabs"]
  s.email       = ["sqa@puppetlabs.com"]
  s.homepage    = "https://github.com/puppetlabs/beaker-rspec"
  s.summary     = %q{RSpec bindings for beaker}
  s.description = %q{RSpec bindings for beaker, see https://github.com/puppetlabs/beaker}
  s.license     = 'Apache-2.0'

  s.required_ruby_version = Gem::Requirement.new('>= 2.1.8', '<3.0.0')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Testing dependencies
  s.add_development_dependency 'minitest', '~> 5.4'
  s.add_development_dependency 'fakefs', '~> 0.6'
  s.add_development_dependency 'rake', '~> 10.1'

  # Documentation dependencies
  s.add_development_dependency 'yard'
  s.add_development_dependency 'thin'

  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.2.2')
    s.add_development_dependency 'rack', '~> 1.6'
  end

  # Run time dependencies
  s.add_runtime_dependency 'beaker', '~> 3.0'
  s.add_runtime_dependency 'rspec', '~> 3.0'
  s.add_runtime_dependency 'serverspec', '~> 2'
  s.add_runtime_dependency 'specinfra', '~> 2'
end
