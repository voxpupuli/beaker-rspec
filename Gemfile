source ENV['GEM_SOURCE'] || "https://rubygems.org"

def location_for(place, fake_version = nil)
  if place =~ /^(git:[^#]*)#(.*)/
    [fake_version, { :git => $1, :branch => $2, :require => false }].compact
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

if (beaker_version = ENV['BEAKER_VERSION'])
  gem 'beaker', *location_for(beaker_version)
end

# For running the spec/acceptance/example_spec.rb
gem 'beaker-vagrant'

# Dependencies for CI acceptance testing; TODO: fix CI so this can be removed
gem 'beaker-hostgenerator'
gem 'beaker-vmpooler', '~> 1.3'

group :release do
  gem 'github_changelog_generator', '>= 1.16.4', require: false if RUBY_VERSION >= '2.5'
end

gemspec
