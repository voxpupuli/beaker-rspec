# beaker-rspec

[![License](https://img.shields.io/github/license/voxpupuli/beaker-rspec.svg)](https://github.com/voxpupuli/beaker-rspec/blob/master/LICENSE)
[![Test](https://github.com/voxpupuli/beaker-rspec/actions/workflows/test.yml/badge.svg)](https://github.com/voxpupuli/beaker-rspec/actions/workflows/test.yml)
[![Release](https://github.com/voxpupuli/beaker-rspec/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/beaker-rspec/actions/workflows/release.yml)
[![RubyGem Version](https://img.shields.io/gem/v/beaker-rspec.svg)](https://rubygems.org/gems/beaker-rspec)
[![RubyGem Downloads](https://img.shields.io/gem/dt/beaker-rspec.svg)](https://rubygems.org/gems/beaker-rspec)
[![Donated by Puppet Inc](https://img.shields.io/badge/donated%20by-Puppet%20Inc-fb7047.svg)](#transfer-notice)

beaker-rspec is a bridge between the puppet acceptance test harness ([beaker](https://github.com/voxpupuli/beaker)) and [rspec](https://github.com/rspec/rspec). It also integrates [serverspec](http://serverspec.org/).

## Upgrading from beaker-rspec 5 to 6

In beaker-rspec 6, we've picked up the newest beaker, 3.y. In this release, we've
given up support for EoL Ruby and moved to 2.4 as our lowest tested version,
as well as a number of other changes underneath.

To learn more about those changes, please checkout our
[how-to upgrade](https://github.com/voxpupuli/beaker/blob/master/docs/how_to/upgrade_from_2_to_3.md)
doc. Note that besides the Ruby version & beaker dependency change, nothing else
was changed in beaker-rspec itself.

To figure out our current lowest supported Ruby version, check for the
`required_ruby_version` key in `beaker-rspec.gemspec`. To see all Ruby versions
we test on, check the list in `.github/workflows/test.yml`.

## Typical Workflow

Beaker does setup and provision all nodes from your nodeset on each test run, and cleans up the VMs after use. During development on a module it can be very handy to keep the VMs available for inspection or reuse. Set `BEAKER_destroy=no` do skip the cleanup and `BEAKER_provision=no` once the VMs are created.

* Run tests with `BEAKER_destroy=no`, no setting for `BEAKER_provision`
    * beaker-rspec will use spec/acceptance/nodesets/default.yml node file
    * boxes will be newly provisioned
    * boxes will be preserved post-testing

* Run tests with `BEAKER_destroy=no` and `BEAKER_provision=no`
    * beaker-rspec will use spec/acceptance/nodesets/default.yml node file
    * boxes will be re-used from previous run
    * boxes will be preserved post-testing
    * Nodes become corrupted with too many test runs/bad data and need to be refreshed then set `BEAKER_provision=yes`
    * Testing is complete and you want to clean up, run once more with `BEAKER_destroy` unset
    * you can also:

```
cd .vagrant/beaker_vagrant_files/default.yml ; vagrant destroy --force
```

### Supported ENV variables

* `BEAKER_color`: set to `no` to disable color output
* `BEAKER_debug`: set to any value to enable beaker debug logging
* `BEAKER_destroy`: set to `no` to keep the VMs after the test run. Set to `onpass` to keep the VMs around only after a test failure.
* `BEAKER_keyfile`: specify alternate SSH key to access the test VMs
* `BEAKER_options_file`: set to the file path of the options file to be used as the default options for beaker.  Equivalent to the `--options-file` parameter.
* `BEAKER_provision`: set to `no` to skip provisioning boxes before testing, beaker will then assume that boxes are already provisioned and reachable
* `BEAKER_setdir`: change the directory with nodesets. Defaults to the module's `spec/acceptance/nodesets` directory.
* `BEAKER_set`: set to the name of the node file to be used during testing (exclude .yml file extension, it will be added by beaker-rspec). The file is assumed to be in the `setdir` (see `BEAKER_setdir`).
* `BEAKER_setfile` - set to the full path to a node file be used during testing (be sure to include full path and file extensions, beaker-rspec will use this path without editing/altering it in any way)

For details on the specific mappings, the [setup code](https://github.com/voxpupuli/beaker-rspec/blob/2771b4b1864692690254a969680a57ff22ac0516/lib/beaker-rspec/spec_helper.rb#L26-L32) and the [beaker docs](https://github.com/voxpupuli/beaker/blob/master/docs/tutorials/the_command_line.md).

## Building your Module Testing Environment

Using puppetlabs-mysql as an example module.

### Clone the module repository of the module where you want to add tests

    git clone https://github.com/puppetlabs/puppetlabs-mysql
    cd puppetlabs-mysql

### Install beaker-rspec

In module's top level directory edit the Gemfile. You should see a `:system_tests`
or `:acceptance` group there, but if not, add beaker-rspec there:

```ruby
group :acceptance do
  gem 'beaker-rspec'
end
```

Then run

    bundle install

### Create node files

These files indicate the nodes (or hosts) that the tests will be run on.  By default, any node file called `default.yml` will be used.  You can override this using the `BEAKER_set` environment variable to indicate an alternate file.  Do not provide full path or the '.yml' file extension to `BEAKER_set`, beaker-rspec expands the filename to '${DIR}/${NAME}.yml'.  The directory defaults to `spec/acceptance/nodesets` but can be overridden with the `BEAKER_setdir` variable.  `BEAKER_setdir` gives full control over the path (including file extension).

Nodes are pulled from [Puppet Labs Vagrant Boxes](https://vagrantcloud.com/puppetlabs).

Example node files can be found here:

* [Puppet Labs example Vagrant node files](https://github.com/voxpupuli/beaker-vagrant/blob/master/docs/vagrant_hosts_file_examples.md)

Create the nodesets directory.  From module's top level directory:

    mkdir -p spec/acceptance/nodesets

Copy any nodesets that you wish to use into the nodesets directory.

### Create the spec_helper_acceptance.rb

In the `spec` folder, you should see the project's `spec_helper_acceptance.rb`.
This file contains all of the setup logic needed to get your Systems Under Test
(SUTs) ready for testing. Note that puppetlabs-mysql's `spec_helper_acceptance.rb`
file can be a little intimidating, so we're going to leave getting familiar with
that to a later exercise. For now, create your own helper in the same directory.
For example, `my_spec_helper_acceptance.rb` (creative, no?):

```ruby
require 'beaker-rspec'

logger.error("LOADED MYYYYYYYYYY Spec Acceptance Helper")

# Install Puppet on all hosts
install_puppet_on(hosts, options)

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    # Install module to all hosts
    hosts.each do |host|
      install_dev_puppet_module_on(host, :source => module_root, :module_name => 'mysql',
          :target_module_path => '/etc/puppet/modules')
      # Install dependencies
      on(host, puppet('module', 'install', 'puppetlabs-stdlib'))

      # Add more setup code as needed
    end
  end
end
```

**NOTE** that the `install_puppet_on` method used above will install the latest
Puppet 3.x version. If you'd like to install a more modern version, you can
replace that line with this one:

```ruby
install_puppet_agent_on(hosts, options)
```

This method will install the latest puppet-agent from the specified
[puppet collection](https://docs.puppet.com/puppet/latest/reference/puppet_collections.html)
(defaults to `pc1`).

Update spec_helper_acceptance.rb to reflect the module under test.  You will need to set the correct module name and add any module dependencies.  Place the file in the `spec` directory (in this case `puppetlabs-mysql/spec`)

### Create spec tests for your module

Spec tests are written in [RSpec](http://rspec.info). You can also use [serverspec](http://serverspec.org/) matchers to test [resources](http://serverspec.org/resource_types.html).

Example spec file `spec/acceptance/mysql_account_delete_spec.rb`:

```ruby
# NOTE: the require must match the name of the helper file created above.
#   If you changed the name there, you'll have to change it here.
#   You can verify this is correct when you see the log statement from the helper.
require 'my_spec_helper_acceptance'

describe 'mysql::server::account_security class' do
  let(:manifest) {
    <<-EOS
      class { 'mysql::server': remove_default_accounts => true }
    EOS
  }

  it 'should run without errors' do
    result = apply_manifest(manifest, :catch_failures => true)
    expect(@result.exit_code).to eq 2
  end

  it 'should delete accounts' do
    grants_results = shell("mysql -e 'show grants for root@127.0.0.1;'")
    expect(grants_results.exit_code).to eq 1
  end

  it 'should delete databases' do
    show_result = shell("mysql -e 'show databases;'")
    expect(show_result.stdout).not_to match /test/
  end

  it 'should run a second time without changes' do
    result = apply_manifest(manifest, :catch_failures => true)
    expect(@result.exit_code).to eq 0
  end

  describe package('mysql-server') do
    it { is_expected.to be_installed }
  end
end
```

### Run your spec tests

From module's top level directory

```
bundle exec rspec spec/acceptance
```

## Transfer Notice

This plugin was originally authored by [Puppet Inc](http://puppet.com).
The maintainer preferred that [Vox Pupuli](https://voxpupuli.org) take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute here.

Previously: https://github.com/puppetlabs/beaker

## License

This gem is licensed under the Apache-2 license.

## Release information

To make a new release, please do:
* update the version in lib/beaker-rspec/version.rb
* Install gems with `bundle install --with release --path .vendor`
* generate the changelog with `bundle exec rake changelog`
* Check if the new version matches the closed issues/PRs in the changelog
* Create a PR with it
* After it got merged, push a tag. GitHub actions will do the actual release to rubygems and GitHub Packages
