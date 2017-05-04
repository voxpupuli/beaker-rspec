require 'beaker-rspec/beaker_shim'
require "beaker-rspec/helpers/serverspec"
include BeakerRSpec::BeakerShim

RSpec.configure do |c|
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
    :nodesetfile => ENV['BEAKER_setfile'] || ENV['RS_SETFILE'],
    :provision   => ENV['BEAKER_provision'] || ENV['RS_PROVISION'],
    :keyfile     => ENV['BEAKER_keyfile'] || ENV['RS_KEYFILE'],
    :debug       => ENV['BEAKER_debug'] || ENV['RS_DEBUG'],
    :destroy     => ENV['BEAKER_destroy'] || ENV['RS_DESTROY'],
    :optionsfile => ENV['BEAKER_options_file'] || ENV['RS_OPTIONS_FILE'],
   }.delete_if {|key, value| value.nil?}
   #combine defaults and env_vars to determine overall options
   options = defaults.merge(env_vars)

  # process options to construct beaker command string
  nodesetfile = options[:nodesetfile] || File.join('spec/acceptance/nodesets',"#{options[:nodeset]}.yml")
  fresh_nodes = options[:provision] == 'no' ? '--no-provision' : nil
  keyfile = options[:keyfile] ? ['--keyfile', options[:keyfile]] : nil
  debug = options[:debug] ? ['--log-level', 'debug'] : nil
  color = options[:color] == 'no' ? ['--no-color'] : nil
  options_file = options[:optionsfile] ? ['--options-file',options[:optionsfile]] || nil

  # Configure all nodes in nodeset
  c.setup([fresh_nodes, '--hosts', nodesetfile, keyfile, debug, color, options_file]).flatten.compact)
  c.provision
  c.validate
  c.configure

  trap "SIGINT" do
    c.cleanup
    exit!(1)
  end

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
