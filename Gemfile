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

beaker_version = ENV['BEAKER_VERSION']

if beaker_version
  gem 'beaker', *location_for(beaker_version)
else
  gem 'beaker'
end

# For running the spec/acceptance/example_spec.rb
gem 'beaker-vagrant'

gemspec
