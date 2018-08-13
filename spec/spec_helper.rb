# if you need DSL extension libraries, it appears that they have to be loaded before the RSpec shim
require "beaker-pe"

ENV['RS_SETFILE'] ||= 'sample.cfg'

require "beaker-rspec"
