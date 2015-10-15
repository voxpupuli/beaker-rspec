beaker-rspec
============

Bridge between puppet test harness (beaker)[https://github.com/puppetlabs/beaker] and (rspec)[https://github.com/rspec/rspec].


Runtime
-------

Require beaker-rspec at the top of your `spec_helper_acceptance.rb` to have it initialize beaker for you:

~~~
require 'beaker-rspec/spec_helper'
~~~

By default it will load the nodeset from `spec/acceptance/nodesets/default.yml`. The tests will then have access to those hosts.

The following environment variables can be used to influence how beaker works:

* `BEAKER_color`: set to `no` to disable color output
* `BEAKER_set`: choose a nodeset from `spec/acceptance/nodesets/*.yml`; defaults to `default`
* `BEAKER_setfile`: specify a nodeset using a full path
* `BEAKER_provision`: set to `no` to re-use existing VMs
* `BEAKER_keyfile`: specify alternate SSH key
* `BEAKER_debug`: set to any value to enable beaker debug logging
* `BEAKER_destroy`: set to `no` to keep the VMs after the test run. Set to `onpass` to keep the VMs around only after a test failure. 

For details on the specific mappings, the [setup code](https://github.com/puppetlabs/beaker-rspec/blob/master/lib/beaker-rspec/spec_helper.rb#L26-L32) and the [beaker docs](https://github.com/puppetlabs/beaker/wiki/The-Command-Line).
