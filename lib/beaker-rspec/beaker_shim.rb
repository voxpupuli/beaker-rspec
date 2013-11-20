require 'beaker'

module BeakerRSpec
  module BeakerShim
    include Beaker::DSL

    CLONEDIR = "puppet"
    HELPER = "puppet/acceptance/lib/helper.rb"
    GITPRESUITE = "puppet/acceptance/config/el6/setup/git/pre-suite"

    def logger
      @logger
    end

    def options
      @options
    end

    def config
      @config
    end

    def clone_puppet_acceptance
      FileUtils.rm_rf(CLONEDIR)
      FileUtils.mkdir_p(CLONEDIR)
      Dir.chdir(CLONEDIR) do
        system("git init")
        system("git remote add puppet https://github.com/puppetlabs/puppet")
        system("git config core.sparsecheckout true")
        File.open('.git/info/sparse-checkout', 'a') { |f| f.write('acceptance') }
        system("git pull puppet master")
        system("git config core.sparsecheckout false")
      end
    end

    def do_git_pre_test
      clone_puppet_acceptance
      require File.expand_path(HELPER)
      @options[:pre_suite] = @options_parser.file_list([GITPRESUITE])
      Beaker::TestSuite.new(
        :pre_suite, @hosts, @options, "stop"
      ).run_and_raise_on_failure
    end

    def provision
      @network_manager = Beaker::NetworkManager.new(@options, @logger)
      RSpec.configuration.hosts = @network_manager.provision
    end

    def validate
      Beaker::Utils::Validator.validate(RSpec.configuration.hosts, @logger)
    end

    def setup(args = [])
      @options_parser = Beaker::Options::Parser.new
      @options = @options_parser.parse_args(args)
      @options[:debug] = true
      @logger = Beaker::Logger.new(@options)
      @options[:logger] = @logger
      RSpec.configuration.hosts = []
    end

    def hosts
      RSpec.configuration.hosts
    end

    def cleanup
      @network_manager.cleanup
    end

    def puppet_module_install opts = {}
      hosts.each do |host|
        scp_to host, opts[:source], File.join(host['distmoduledir'], opts[:module_name])
      end
    end

  end
end
