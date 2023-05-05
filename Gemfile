source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place, fake_version = nil)
  if place =~ /^(git:[^#]*)#(.*)/
    [fake_version, { git: Regexp.last_match(1), branch: Regexp.last_match(2), require: false }].compact
  elsif place =~ %r{^file://(.*)}
    ['>= 0', { path: File.expand_path(Regexp.last_match(1)), require: false }]
  else
    [place, { require: false }]
  end
end

if (beaker_version = ENV.fetch('BEAKER_VERSION', nil))
  gem 'beaker', *location_for(beaker_version)
end

case ENV.fetch('BEAKER_HYPERVISOR', nil)
when 'docker'
  gem 'beaker-docker'
when 'vagrant', 'vagrant_libvirt'
  gem 'beaker-vagrant'
when 'vmpooler'
  gem 'beaker-vmpooler', '~> 1.3'
end

group :release do
  gem 'faraday-retry', require: false
  gem 'github_changelog_generator', require: false
end

gemspec
