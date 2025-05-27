# frozen_string_literal: true

require 'beaker-rspec/beaker_shim'
require 'beaker-rspec/helpers/serverspec'
include BeakerRSpec::BeakerShim

RSpec.configure do |c|
  # Enable color
  c.tty = true

  # Define persistant hosts setting
  c.add_setting :hosts, default: []
  # Define persistant options setting
  c.add_setting :options, default: {}
  # Define persistant metadata object
  c.add_setting :metadata, default: {}
  # Define persistant logger object
  c.add_setting :logger, default: nil
  # Define persistant default node
  c.add_setting :default_node, default: nil

  # default option values
  defaults = {
    nodeset: 'default',
  }
  # read env vars
  env_vars = {
    color: ENV['BEAKER_COLOR'] || ENV['BEAKER_color'] || ENV.fetch('RS_COLOR', nil),
    nodeset: ENV['BEAKER_SET'] || ENV['BEAKER_set'] || ENV.fetch('RS_SET', nil),
    nodesetdir: ENV['BEAKER_SETDIR'] || ENV['BEAKER_setdir'] || ENV.fetch('RS_SETDIR', nil),
    nodesetfile: ENV['BEAKER_SETFILE'] || ENV['BEAKER_setfile'] || ENV.fetch('RS_SETFILE', nil),
    provision: ENV['BEAKER_PROVISION'] || ENV['BEAKER_provision'] || ENV.fetch('RS_PROVISION', nil),
    keyfile: ENV['BEAKER_KEYFILE'] || ENV['BEAKER_keyfile'] || ENV.fetch('RS_KEYFILE', nil),
    debug: ENV['BEAKER_DEBUG'] || ENV['BEAKER_debug'] || ENV.fetch('RS_DEBUG', nil),
    destroy: ENV['BEAKER_DESTROY'] || ENV['BEAKER_destroy'] || ENV.fetch('RS_DESTROY', nil),
    optionsfile: ENV['BEAKER_OPTIONS_FILE'] || ENV['BEAKER_options_file'] || ENV.fetch('RS_OPTIONS_FILE', nil),
    vagrant_memsize: ENV.fetch('BEAKER_VAGRANT_MEMSIZE', nil),
    vagrant_cpus: ENV.fetch('BEAKER_VAGRANT_CPUS', nil),
  }.compact
  # combine defaults and env_vars to determine overall options
  options = defaults.merge(env_vars)

  # process options to construct beaker command string
  nodesetdir = options[:nodesetdir] || File.join('spec', 'acceptance', 'nodesets')
  nodesetfile = options[:nodesetfile] || File.join(nodesetdir, "#{options[:nodeset]}.yml")
  fresh_nodes = (options[:provision] == 'no') ? '--no-provision' : nil
  keyfile = options[:keyfile] ? ['--keyfile', options[:keyfile]] : nil
  debug = (options[:debug] && options[:debug] != 'no') ? ['--log-level', 'debug'] : nil
  color = (options[:color] == 'no') ? ['--no-color'] : nil
  options_file = options[:optionsfile] ? ['--options-file', options[:optionsfile]] : nil

  # Configure all nodes in nodeset
  c.setup([fresh_nodes, '--hosts', nodesetfile, keyfile, debug, color, options_file].flatten.compact)

  trap 'SIGINT' do
    c.cleanup
    exit!(1)
  end

  begin
    c.provision
  rescue StandardError => e
    logger.error(e)
    logger.info(e.backtrace)
    c.cleanup
    exit!(1)
  end

  c.validate
  c.configure

  # Destroy nodes if no preserve hosts
  c.after :suite do
    case options[:destroy]
    when 'no'
      # Don't cleanup
    when 'onpass'
      c.cleanup if RSpec.world.filtered_examples.values.flatten.none?(&:exception)
    else
      c.cleanup
    end
  end
end
