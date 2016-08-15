#beaker-rspec

beaker-rspec is a bridge between the puppet acceptance test harness ([beaker](https://github.com/puppetlabs/beaker)) and [rspec](https://github.com/rspec/rspec). It also integrates [serverspec](http://serverspec.org/).

#Typical Workflow

Beaker does setup and provision all nodes from your nodeset on each test run, and cleans up the VMs after use. During development on a module it can be very handy to keep the VMs available for inspection or reuse. Set `BEAKER_destroy=no` do skip the cleanup and `BEAKER_provision=no` once the VMs are created.

1. Run tests with `BEAKER_destroy=no`, no setting for `BEAKER_provision`
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

        cd .vagrant/beaker_vagrant_files/default.yml ; vagrant destroy --force

##Supported ENV variables

* `BEAKER_color`: set to `no` to disable color output
* `BEAKER_debug`: set to any value to enable beaker debug logging
* `BEAKER_destroy`: set to `no` to keep the VMs after the test run. Set to `onpass` to keep the VMs around only after a test failure.
* `BEAKER_keyfile`: specify alternate SSH key to access the test VMs
* `BEAKER_provision`: set to `no` to skip provisioning boxes before testing, beaker will then assume that boxes are already provisioned and reachable
* `BEAKER_set`: set to the name of the node file to be used during testing (exclude .yml file extension, it will be added by beaker-rspec). The file is assumed to be in module's spec/acceptance/nodesets directory.
* `BEAKER_setfile` - set to the full path to a node file be used during testing (be sure to include full path and file extensions, beaker-rspec will use this path without editing/altering it in any way)

For details on the specific mappings, the [setup code](https://github.com/puppetlabs/beaker-rspec/blob/2771b4b1864692690254a969680a57ff22ac0516/lib/beaker-rspec/spec_helper.rb#L26-L32) and the [beaker docs](https://github.com/puppetlabs/beaker/blob/master/docs/tutorials/the_command_line.md).

#Building your Module Testing Environment

Using puppetlabs-mysql as an example module.

##Clone the module repository of the module where you want to add tests

    git clone https://github.com/puppetlabs/puppetlabs-mysql
    cd puppetlabs-mysql

##Install beaker-rspec

In module's top level directory edit the Gemfile. If there is a `:system_tests` or `:acceptance` group, add it there.

```ruby
group :acceptance do
  gem 'beaker-rspec'
end
```

Then run

    bundle install

##Create node files

These files indicate the nodes (or hosts) that the tests will be run on.  By default, any node file called `default.yml` will be used.  You can override this using the `BEAKER_set` environment variable to indicate an alternate file.  Do not provide full path or the '.yml' file extension to `BEAKER_set`, it is assumed to be located in 'spec/acceptance/nodesets/${NAME}.yml' by beaker-rspec.  If you wish to use a completely different file location use `BEAKER_setfile` and set it to the full path (including file extension) of your hosts file.

Nodes are pulled from [Puppet Labs Vagrant Boxes](https://vagrantcloud.com/puppetlabs).

Example node files can be found here:

* [Puppet Labs example Vagrant node files](https://github.com/puppetlabs/beaker/blob/master/docs/how_to/hypervisors/vagrant_hosts_file_examples.md)

Create the nodesets directory.  From module's top level directory:

    mkdir -p spec/acceptance/nodesets

Copy any nodesets that you wish to use into the nodesets directory.

##Create the spec_helper_acceptance.rb

Create example file `spec_helper_acceptance.rb`:

```ruby
require 'beaker-rspec'
require 'pry'

# Install Puppet on all hosts
hosts.each do |host|
  on host, install_puppet
end

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

Update spec_helper_acceptance.rb to reflect the module under test.  You will need to set the correct module name and add any module dependencies.  Place the file in the `spec` directory (in this case `puppetlabs-mysql/spec`)

##Create spec tests for your module

Spec tests are written in [RSpec](http://rspec.info). You can also use [serverspec](http://serverspec.org/) matchers to test [resources](http://serverspec.org/resource_types.html).

Example spec file `spec/acceptance/mysql_account_delete_spec.rb`:

```ruby
require 'spec_helper_acceptance'

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

##Run your spec tests

From module's top level directory

    bundle exec rspec spec/acceptance
