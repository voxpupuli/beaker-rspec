require 'beaker-rspec/beaker_shim'
require "beaker-rspec/helpers/serverspec"
require "beaker-rspec/matchers/apply"
include BeakerRSpec::BeakerShim

RSpec.configure do |c|
  c.include BeakerRSpec::Matchers::Apply

  # Enable color
  c.tty = true

  # Define persistant hosts setting
  c.add_setting :hosts, :default => []
  # Define persistant options setting
  c.add_setting :options, :default => {}
  # Define persistant metadata object
  c.add_setting :metadata, :default => {}
  # Define persistant logger object
  c.add_setting :logger, :default => nil
  # Define persistant default node
  c.add_setting :default_node, :default => nil

  #default option values
  defaults = {
    :nodeset     => 'default',
  }
  #read env vars
  env_vars = {
    :color       => ENV['BEAKER_color'] || ENV['RS_COLOR'],
    :nodeset     => ENV['BEAKER_set'] || ENV['RS_SET'],
    :nodesetdir  => ENV['BEAKER_setdir'] || ENV['RS_SETDIR'],
    :nodesetfile => ENV['BEAKER_setfile'] || ENV['RS_SETFILE'],
    :provision   => ENV['BEAKER_provision'] || ENV['RS_PROVISION'],
    :keyfile     => ENV['BEAKER_keyfile'] || ENV['RS_KEYFILE'],
    :debug       => ENV['BEAKER_debug'] || ENV['RS_DEBUG'],
    :destroy     => ENV['BEAKER_destroy'] || ENV['RS_DESTROY'],
    :optionsfile => ENV['BEAKER_options_file'] || ENV['RS_OPTIONS_FILE'],
   }.delete_if {|_key, value| value.nil?}
   #combine defaults and env_vars to determine overall options
   options = defaults.merge(env_vars)

  # process options to construct beaker command string
  nodesetdir = options[:nodesetdir] || File.join('spec', 'acceptance', 'nodesets')
  nodesetfile = options[:nodesetfile] || File.join(nodesetdir, "#{options[:nodeset]}.yml")
  fresh_nodes = options[:provision] == 'no' ? '--no-provision' : nil
  keyfile = options[:keyfile] ? ['--keyfile', options[:keyfile]] : nil
  debug = options[:debug] && options[:debug] != 'no' ? ['--log-level', 'debug'] : nil
  color = options[:color] == 'no' ? ['--no-color'] : nil
  options_file = options[:optionsfile] ? ['--options-file',options[:optionsfile]] : nil

  # Configure all nodes in nodeset
  c.setup([fresh_nodes, '--hosts', nodesetfile, keyfile, debug, color, options_file].flatten.compact)

  trap "SIGINT" do
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
