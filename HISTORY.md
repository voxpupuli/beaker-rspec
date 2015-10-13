# default - History
## Tags
* [LATEST - 13 Oct, 2015 (2ea88c14)](#LATEST)
* [5.2.2 - 3 Sep, 2015 (69980e14)](#5.2.2)
* [5.2.1 - 27 Aug, 2015 (49c45f61)](#5.2.1)
* [5.2.0 - 15 Jul, 2015 (261dacdb)](#5.2.0)
* [5.1.0 - 5 Jun, 2015 (3a72d131)](#5.1.0)
* [beaker-rspec5.0.2 - 30 Mar, 2015 (b9831088)](#beaker-rspec5.0.2)
* [beaker-rspec5.0.1 - 27 Jan, 2015 (7a64f285)](#beaker-rspec5.0.1)
* [beaker-rspec5.0.0 - 8 Jan, 2015 (bbf806a4)](#beaker-rspec5.0.0)
* [beaker-rspec4.0.0 - 5 Dec, 2014 (a4fe104a)](#beaker-rspec4.0.0)
* [beaker-rspec2.2.6 - 23 Jun, 2014 (c899b70b)](#beaker-rspec2.2.6)
* [beaker-rspec2.2.5 - 19 Jun, 2014 (4b9253e3)](#beaker-rspec2.2.5)
* [beaker-rspec2.2.4 - 8 May, 2014 (8fdb93a9)](#beaker-rspec2.2.4)
* [beaker-rspec2.2.3 - 23 Apr, 2014 (81241746)](#beaker-rspec2.2.3)
* [beaker-rspec2.2.2 - 27 Mar, 2014 (bd5717e6)](#beaker-rspec2.2.2)
* [beaker-rspec2.2.1 - 24 Mar, 2014 (5ec50c57)](#beaker-rspec2.2.1)
* [beaker-rspec2.2.0 - 13 Mar, 2014 (3f2cd006)](#beaker-rspec2.2.0)
* [beaker-rspec2.1.1 - 30 Jan, 2014 (94e2423a)](#beaker-rspec2.1.1)
* [beaker-rspec2.1.0 - 29 Jan, 2014 (3ffb18f1)](#beaker-rspec2.1.0)
* [beaker-rspec2.0.1 - 22 Jan, 2014 (0ece0e8d)](#beaker-rspec2.0.1)
* [beaker-rspec2.0.0 - 6 Dec, 2013 (d836ebac)](#beaker-rspec2.0.0)
* [beaker-rspec1.0.0 - 3 Dec, 2013 (65e89ec9)](#beaker-rspec1.0.0)

## Details
### <a name = "LATEST">LATEST - 13 Oct, 2015 (2ea88c14)

* (GEM) update beaker-rspec version to 5.3.0 (2ea88c14)

* Merge pull request #73 from rooprob/feature/enable-beaker-proxy-support (aec28793)


```
Merge pull request #73 from rooprob/feature/enable-beaker-proxy-support

Enable the proxy feature available in beaker cli.
```
* Enable the proxy feature available in beaker cli. (1eeda73f)


```
Enable the proxy feature available in beaker cli.

Improves acceptance testing performance and lowers network traffic to package
respositories with beaker-rspec.

Running a suitably configured proxy cache to act as a package cache, add the
following nodeset configuration.



---
CONFIG:
  package_proxy: http://<proxy_addr>:<proxy_port>



Beaker supports Debian (APT) and RHEL/Centos (RPM) based package proxies out of the box. See beaker --help (package-proxy) for further details.

Example, Squid is a suitable local package cache,

squid.conf


mum_object_size 100 MB
cache_replacement_policy heap LFUDA
refresh_pattern ^ftp:          1440    20%     10080
refresh_pattern ^gopher:       1440    0%      1440
refresh_pattern Packages\.bz2$ 0       20%     4320 refresh-ims
refresh_pattern Sources\.bz2$  0       20%     4320 refresh-ims
refresh_pattern Release\.gpg$  0       20%     4320 refresh-ims
refresh_pattern Release$       0       20%     4320 refresh-ims
refresh_pattern .              0       20%     4320


```
### <a name = "5.2.2">5.2.2 - 3 Sep, 2015 (69980e14)

* (HISTORY) update beaker-rspec history for gem release 5.2.2 (69980e14)

* (GEM) update beaker-rspec version to 5.2.2 (462d5843)

* Merge pull request #75 from anodelman/fix-win (1b3ae6fe)


```
Merge pull request #75 from anodelman/fix-win

(BKR-474) Missing shellescape in /helpers/serverspec.rb since a6b3e503
```
* (BKR-474) Missing shellescape in /helpers/serverspec.rb since a6b3e503 (0229c97a)


```
(BKR-474) Missing shellescape in /helpers/serverspec.rb since a6b3e503

- put the shellescape back in
- tested green locally on osx/windows/ubuntu/centos/debian
```
### <a name = "5.2.1">5.2.1 - 27 Aug, 2015 (49c45f61)

* (HISTORY) update beaker-rspec history for gem release 5.2.1 (49c45f61)

* (GEM) update beaker-rspec version to 5.2.1 (2cc63fcb)

* Merge pull request #72 from anodelman/ruby2 (86157a9d)


```
Merge pull request #72 from anodelman/ruby2

 (BKR-467) beaker-rspec does not correctly update os when cycling through hosts
```
* (BKR-467) beaker-rspec does not correctly update os when cycling... (a6b3e503)


```
(BKR-467) beaker-rspec does not correctly update os when cycling...

...through hosts

- found that beaker was unable to complete its acceptance tests when
  provided with multiple SUTs of multiple os types in the same hosts
  file
- need to correctly detectos when we switch to a new os, otherwise we
  assume that we are executing on the same os and generate the wrong
  command strings
- keeps a hash of known hosts associated with their os type so that we
  don't have to run detect_os (which can be somewhat time expensive)
  more than once per-SUT
```
### <a name = "5.2.0">5.2.0 - 15 Jul, 2015 (261dacdb)

* (HISTORY) update beaker-rspec history for gem release 5.2.0 (261dacdb)

* (GEM) update beaker-rspec version to 5.2.0 (25f27502)

* Merge pull request #70 from cmurphy/colors (80f60a7c)


```
Merge pull request #70 from cmurphy/colors

Add environment variable to expose --no-color
```
* Add environment variable to expose --no-color (d2f8ad39)


```
Add environment variable to expose --no-color

When running CI on puppet modules with beaker-rspec, colors tend to get
mistranslated into hard-to-read ascii strings that make reading logs
painful. This patch adds the option to turn colors off.
```
### <a name = "5.1.0">5.1.0 - 5 Jun, 2015 (3a72d131)

* (HISTORY) update beaker-rspec history for gem release 5.1.0 (3a72d131)

* (GEM) update beaker-rspec version to 5.1.0 (6ca92bf3)

* Merge pull request #69 from anodelman/host-control (44ea85b5)


```
Merge pull request #69 from anodelman/host-control

(BKR-280) ability to install pe/foss on subset of hosts
```
* (BKR-280) ability to install pe/foss on subset of hosts (612dd1ff)


```
(BKR-280) ability to install pe/foss on subset of hosts

- provide a hosts setter so that we can alter the hosts during runtime
```
* Merge pull request #68 from anodelman/standardize (4f564531)


```
Merge pull request #68 from anodelman/standardize

(BKR-286) set up beaker-rspec to use standard gem structure practices
```
* Merge pull request #67 from anodelman/add-beaker-globals (fe32bc1b)


```
Merge pull request #67 from anodelman/add-beaker-globals

(BKR-283) beaker-rspec needs access to @metadata, broken with beaker 2.12.0
```
* (BKR-286) set up beaker-rspec to use standard gem structure practices (c62996be)


```
(BKR-286) set up beaker-rspec to use standard gem structure practices

- this will allow us to use our standard release pipelines
```
* (BKR-283) beaker-rspec needs access to @metadata, broken with... (826455be)


```
(BKR-283) beaker-rspec needs access to @metadata, broken with...

...beaker 2.12.0

- add accessor for metadata
```
* (MAINT) be able to set used beaker using BEAKER_VERSION (a1b64039)

### <a name = "beaker-rspec5.0.2">beaker-rspec5.0.2 - 30 Mar, 2015 (b9831088)

* Merge pull request #62 from anodelman/master (b9831088)


```
Merge pull request #62 from anodelman/master

create 5.0.2 gem
```
* (HISTORY) update beaker-rspec history for gem release 5.0.2 (6f6cfcbf)

* (GEM) update beaker-rspec version to 5.0.2 (7de55221)

* Merge pull request #61 from cyberious/master (26eb29d6)


```
Merge pull request #61 from cyberious/master

BKR-160 Remove check for OS before issuing command, get_windows_command...
```
* BKR-160 Remove check for OS before issuing command, get_windows_command is not declared in scope (addd9b32)

* Merge pull request #60 from anodelman/maint (c4c43fd7)


```
Merge pull request #60 from anodelman/maint

(BKR-60) failures caused by rubygems timeouts
```
* (BKR-60) failures caused by rubygems timeouts (fe36b2d8)


```
(BKR-60) failures caused by rubygems timeouts

- add ability to set GEM_SOURCE to internal rubygems mirror
```
### <a name = "beaker-rspec5.0.1">beaker-rspec5.0.1 - 27 Jan, 2015 (7a64f285)

* Merge pull request #56 from anodelman/master (7a64f285)


```
Merge pull request #56 from anodelman/master

(GEM) version bump for beaker-rspec 5.0.1
```
* (GEM) version bump for beaker-rspec 5.0.1 (510f3be1)

* Merge pull request #55 from anodelman/fix-win (28ae2a27)


```
Merge pull request #55 from anodelman/fix-win

(QENG-1657) Beaker-Rspec Specinfra does not detect Windows OS set
```
* Merge pull request #22 from petems/add_raketask (5e08f02e)


```
Merge pull request #22 from petems/add_raketask

Initial idea for a rake task
```
* (QENG-1657) Beaker-Rspec Specinfra does not detect Windows OS set (56e81ce0)


```
(QENG-1657) Beaker-Rspec Specinfra does not detect Windows OS set

- makes it possible to run against windows nodes with cygwin
- will need updates later to correctly handle windows nodes through
  winrm
```
* Initial idea for a rake task (8f361731)

### <a name = "beaker-rspec5.0.0">beaker-rspec5.0.0 - 8 Jan, 2015 (bbf806a4)

* Merge pull request #52 from anodelman/master (bbf806a4)


```
Merge pull request #52 from anodelman/master

(GEM) version bump for 5.0.0
```
* (GEM) version bump for 5.0.0 (ff1f30d2)

* Merge pull request #51 from electrical/rspec3_support (f133c28e)


```
Merge pull request #51 from electrical/rspec3_support

Rspec3 support
```
* (gh-51) Update to support serverspec/specinfra V2 and rspec3 (fa120293)


```
(gh-51) Update to support serverspec/specinfra V2 and rspec3

Due to some changes in specinfra Ive had to change some code and override some specinfra code
```
### <a name = "beaker-rspec4.0.0">beaker-rspec4.0.0 - 5 Dec, 2014 (a4fe104a)

* Merge pull request #49 from anodelman/master (a4fe104a)


```
Merge pull request #49 from anodelman/master

(QENG-1591) update beaker-rspec to use beaker 2.0
```
* (QENG-1591) update beaker-rspec to use beaker 2.0 (e0e86439)


```
(QENG-1591) update beaker-rspec to use beaker 2.0

- includes update to minitest
```
* Merge pull request #46 from justinstoller/maint/master/make-gem (889eb4c5)


```
Merge pull request #46 from justinstoller/maint/master/make-gem

bump beaker-rspec to 3.0
```
* bump beaker-rspec to 3.0 (e8a2a616)

* Merge pull request #39 from hunner/remove_pm_install (9450a014)


```
Merge pull request #39 from hunner/remove_pm_install

Move puppet_module_install to beaker dsl helpers
```
* Move puppet_module_install to beaker dsl helpers (128556e1)

### <a name = "beaker-rspec2.2.6">beaker-rspec2.2.6 - 23 Jun, 2014 (c899b70b)

* Merge pull request #45 from anodelman/make-gem (c899b70b)


```
Merge pull request #45 from anodelman/make-gem

(GEM) create beaker 2.2.6 gem
```
* (GEM) create beaker 2.2.6 gem (4c1bfe3b)

* Merge pull request #44 from anodelman/maint (16e227cf)


```
Merge pull request #44 from anodelman/maint

(QENG-833) beaker-rspec broken when using beaker 1.13
```
* (QENG-833) beaker-rspec broken when using beaker 1.13 (00e20566)


```
(QENG-833) beaker-rspec broken when using beaker 1.13

- ensure that the logger object is available
```
### <a name = "beaker-rspec2.2.5">beaker-rspec2.2.5 - 19 Jun, 2014 (4b9253e3)

* Merge pull request #43 from hunner/update_specs (4b9253e3)


```
Merge pull request #43 from hunner/update_specs

Remove development dependency
```
* Remove development dependency (13b4e72e)


```
Remove development dependency

Beaker-rspec's tests are already compatible with rspec 3, so no need to
update the specs for the latest rspec
```
* Merge pull request #42 from hunner/release_2.2.5 (e1e6f50a)


```
Merge pull request #42 from hunner/release_2.2.5

Release 2.2.5
```
* Release 2.2.5 (76210e33)


```
Release 2.2.5

Only change is to unpin rspec 2 as a runtime dependency.
```
* Merge pull request #41 from hunner/unpin_rspec (2db68b61)


```
Merge pull request #41 from hunner/unpin_rspec

Unpin rspec
```
* Unpin rspec (6837d3a1)


```
Unpin rspec

rspec 2.x is a development dependency, but the runtime dependency
shouldn't pin to any specific version as the beaker-rspec library
doesn't care.
```
### <a name = "beaker-rspec2.2.4">beaker-rspec2.2.4 - 8 May, 2014 (8fdb93a9)

* Merge pull request #38 from anodelman/make-gem (8fdb93a9)


```
Merge pull request #38 from anodelman/make-gem

create beaker-rspec 2.2.4 gem
```
* create beaker-rspec 2.2.4 gem (caf3e39a)

* Merge pull request #36 from hunner/fix_specinfra_deps (8a3a9192)


```
Merge pull request #36 from hunner/fix_specinfra_deps

(QENG-657) Update specinfra and serverspec deps to be ~>1.0
```
* (QENG-657) Update specinfra and serverspec deps to be ~>1.0 (912c21ad)

### <a name = "beaker-rspec2.2.3">beaker-rspec2.2.3 - 23 Apr, 2014 (81241746)

* Merge pull request #34 from anodelman/make-gem (81241746)


```
Merge pull request #34 from anodelman/make-gem

create beaker-rspec 2.2.3 gem
```
* Merge pull request #33 from anodelman/pin-beaker-minitest (cb112dc8)


```
Merge pull request #33 from anodelman/pin-beaker-minitest

(QENG-596) beaker-rspec dying on minitest dependency
```
* create beaker-rspec 2.2.3 gem (7e6c93cd)

* (QENG-596) beaker-rspec dying on minitest dependency (f5f894f6)


```
(QENG-596) beaker-rspec dying on minitest dependency

- pin minitest to 4.0
- update beaker pin to newest release of 1.10.0
```
### <a name = "beaker-rspec2.2.2">beaker-rspec2.2.2 - 27 Mar, 2014 (bd5717e6)

* Merge pull request #31 from anodelman/update-beaker-version (bd5717e6)


```
Merge pull request #31 from anodelman/update-beaker-version

update beaker-rspec to use beaker 1.9.1
```
* update beaker-rspec to use beaker 1.9.1 (5e6eb3ff)

### <a name = "beaker-rspec2.2.1">beaker-rspec2.2.1 - 24 Mar, 2014 (5ec50c57)

* Merge pull request #28 from anodelman/make-gem (5ec50c57)


```
Merge pull request #28 from anodelman/make-gem

create beaker-rspec 2.2.1 gem
```
* create beaker-rspec 2.2.1 gem (a0adc7ae)

* Merge pull request #27 from anodelman/update-configuration-steps (7dfdb5af)


```
Merge pull request #27 from anodelman/update-configuration-steps

update configuration/validation steps for beaker 1.8.1+ gem
```
* update configuration/validation steps for beaker 1.8.1+ gem (bafcee63)


```
update configuration/validation steps for beaker 1.8.1+ gem

- beaker has changed its configuration/validation steps and beaker-rspec
  will need to be updated as well
- these changes will need to be run with beaker 1.8.1+
```
### <a name = "beaker-rspec2.2.0">beaker-rspec2.2.0 - 13 Mar, 2014 (3f2cd006)

* Merge pull request #25 from anodelman/make-gem (3f2cd006)


```
Merge pull request #25 from anodelman/make-gem

create beaker-rspec 2.2.0 gem
```
* create beaker-rspec 2.2.0 gem (35b44546)


```
create beaker-rspec 2.2.0 gem

- add support for BEAKER_*name* env var format
```
* Merge pull request #24 from anodelman/beaker-env (3ac1f383)


```
Merge pull request #24 from anodelman/beaker-env

normalize env var handling
```
* normalize env var handling (00c70ed4)


```
normalize env var handling

- have all env vars start with BEAKER_
- process all env vars in one hash
- set all default values in one hash
```
### <a name = "beaker-rspec2.1.1">beaker-rspec2.1.1 - 30 Jan, 2014 (94e2423a)

* Merge pull request #20 from anodelman/make-gem (94e2423a)


```
Merge pull request #20 from anodelman/make-gem

create beaker-rspec 2.1.1 gem
```
* create beaker-rspec 2.1.1 gem (a19acf47)

* Merge pull request #18 from hunner/fix_destroy (26a52d79)


```
Merge pull request #18 from hunner/fix_destroy

Patch RS_DESTROY behavior
```
* Patch RS_DESTROY behavior (5161054d)


```
Patch RS_DESTROY behavior

QA-723's implementation moved the logic for `@options[:preserve_hosts]`
out of the `Beaker::NetworkManager#cleanup` method to
`Beaker::CLI#execute!` and beaker-rspec doesn't use the CLI, so the
logic would have to be duplicated here, or beaker would need a patch to
move it back.

It doesn't really make sense for the cleanup method to conditionally
cleanup, and it doesn't make sense for beaker to be inspecting the
success state of RSpec, so beaker-rspec can be changed to work.
```
### <a name = "beaker-rspec2.1.0">beaker-rspec2.1.0 - 29 Jan, 2014 (3ffb18f1)

* Merge pull request #17 from anodelman/make-gem (3ffb18f1)


```
Merge pull request #17 from anodelman/make-gem

create beaker-rspec 2.1.0 gem
```
* create beaker-rspec 2.1.0 gem (b28fd561)

* Merge pull request #16 from hunner/preserve_hosts (6418ba11)


```
Merge pull request #16 from hunner/preserve_hosts

Update argument passing for RS_DESTROY
```
* Merge pull request #15 from apenney/fix-serverspec (c1fe9385)


```
Merge pull request #15 from apenney/fix-serverspec

specinfra 0.5.0 has made some changes that break run_command for us,
```
* Update argument passing for RS_DESTROY (80ab123b)

* specinfra 0.5.0 has made some changes that break run_command for us, (860658b8)


```
specinfra 0.5.0 has made some changes that break run_command for us,
get the ret from CommandResult.new now.
```
### <a name = "beaker-rspec2.0.1">beaker-rspec2.0.1 - 22 Jan, 2014 (0ece0e8d)

* Merge pull request #13 from anodelman/repair-gemspec (0ece0e8d)


```
Merge pull request #13 from anodelman/repair-gemspec

repair beaker-rspec.gemspec
```
* Merge pull request #14 from anodelman/setfile (395fb9fc)


```
Merge pull request #14 from anodelman/setfile

env var fixes to allow for jenkins integration
```
* env var fixes to allow for jenkins integration (9b35685e)


```
env var fixes to allow for jenkins integration

- allow for setting RS_SETFILE when running spec tests
- addition of RS_KEYFILE and RS_DEBUG
```
* repair beaker-rspec.gemspec (7e88246b)


```
repair beaker-rspec.gemspec

- raises warnings on open-ended dependencies
- duplicate dependency on rspec
```
* Merge pull request #11 from anodelman/make-gem (13453bf4)


```
Merge pull request #11 from anodelman/make-gem

beaker-rspec 2.0.1 gem
```
* Merge pull request #12 from anodelman/default-options (e183651a)


```
Merge pull request #12 from anodelman/default-options

remove "--type git" from spec_helper.cfg
```
* remove "--type git" from spec_helper.cfg (fd3626b8)


```
remove "--type git" from spec_helper.cfg

- set the type from within the given node configuration file
```
* beaker-rspec 2.0.1 gem (4c22e3d9)


```
beaker-rspec 2.0.1 gem

- fixes support for options hash
- install_pe now works
```
* Merge pull request #10 from anodelman/access-options-hash (7bfeb5b9)


```
Merge pull request #10 from anodelman/access-options-hash

(QE-628) install_pe needs to work with beaker-rspec
```
* (QE-628) install_pe needs to work with beaker-rspec (3fc9776e)


```
(QE-628) install_pe needs to work with beaker-rspec

- add access to the options hash from beaker-rspec
```
### <a name = "beaker-rspec2.0.0">beaker-rspec2.0.0 - 6 Dec, 2013 (d836ebac)

* Merge pull request #9 from anodelman/make-gem (d836ebac)


```
Merge pull request #9 from anodelman/make-gem

create 2.0.0 beaker-rspec gem
```
* create 2.0.0 beaker-rspec gem (09180d72)


```
create 2.0.0 beaker-rspec gem

- upping to 2.0.0 because of change in ENV var support
```
* Merge pull request #8 from anodelman/fix-env-vars (422bb9c6)


```
Merge pull request #8 from anodelman/fix-env-vars

(QE-603) RSPEC_DESTROY and RSPEC_NO_PROVISION need to be clarified
```
* (QE-603) RSPEC_DESTROY and RSPEC_NO_PROVISION need to be clarified (54ff767c)


```
(QE-603) RSPEC_DESTROY and RSPEC_NO_PROVISION need to be clarified

- using RS_DESTROY=no for not destroying boxes post-test
- using RS_PROVISION=no for not provisioning boxes before tests
```
### <a name = "beaker-rspec1.0.0">beaker-rspec1.0.0 - 3 Dec, 2013 (65e89ec9)

* Initial release.
