require 'rspec'
require '../rspec/lib/beaker-rspec/beaker_shim'
require 'pry'
require 'specinfra'

class BeakerShimTester
  include BeakerRSpec::BeakerShim
end
describe BeakerRSpec::BeakerShim do
  let(:subject) { BeakerShimTester.new() }
  let(:should_be_list) { ['Modulefile', 'metadata.json', 'lib', 'files', 'templates'] }
  let(:should_not_be_list) { ['.', '..', '.vagrant', '.git', 'acceptance', 'tests'] }
  let(:ignore_list) { nil }

  def hosts_for_context(distdirs)
    hosts = []
    distdirs.each do |distdir|
      host = double("host")
      host.stub(:[]).with('distmoduledir').and_return(distdir)
      hosts << host
    end
    hosts
  end

  shared_context "host_context" do
    let(:hosts) { hosts_for_context ['/etc/puppetlabs/puppet/modules'] }
  end

  def should_scp_stub(hosts, should_be_list, should_not_be_list)
    Dir.stub(:glob).and_return(should_be_list.zip(should_not_be_list).flatten.select { |i| !i.nil? })

    hosts.each do |host|
      should_be_list.each do |item|
        subject.should_receive(:scp_to).with(host, "./#{item}", "/etc/puppetlabs/puppet/modules/bogusMod/#{item}").once
      end
      should_not_be_list.each do |item|
        subject.should_not_receive(:scp_to).with(host, "./#{item}", anything())
      end
    end
  end

  describe "#puppet_module_install_on" do
    shared_examples "puppet_module_examples" do
      include_context "host_context"
      it {
        should_scp_stub(hosts, should_be_list, should_not_be_list)
        host = hosts[0]
        opts = { :source => './', :module_name => 'bogusMod', :ignore_list => ignore_list }
        subject.puppet_module_install_on(host, opts)
      }
    end

    describe "default behavior" do
      it_behaves_like "puppet_module_examples"
    end

    describe "override behavior" do
      let(:ignore_list) { ['.git', '.idea', '.vagrant', 'spec', 'tests', 'log'] }
      let(:should_not_be_list) { ['.', '..', '.vagrant', '.git', 'tests'] }
      let(:should_be_list) { ['Modulefile', 'metadata.json', 'lib', 'files', 'templates', 'acceptance'] }
      it_behaves_like "puppet_module_examples"
    end

  end

  describe "#puppet_module_install" do

    describe "default behavior" do
      include_context "host_context"
      should_not_be_list =[".", ".."]
      should_be_list = ['Modulefile', 'metadata.json', 'lib', 'files', 'templates', '.vagrant', '.git', 'acceptance', 'tests']
      it {
        subject.stub(:hosts).and_return(hosts)
        should_scp_stub(hosts, should_be_list, should_not_be_list)
        opts = { :source => './', :module_name => 'bogusMod' }
        subject.puppet_module_install opts
      }
    end
    describe "using_ignore_list" do
      include_context "host_context"
      it {
        subject.stub(:hosts).and_return(hosts)
        should_scp_stub(hosts, should_be_list, should_not_be_list)
        opts = { :source => './', :module_name => 'bogusMod', :ignore_list => ['.git','.vagrant','tests','acceptance'] }
        subject.puppet_module_install opts
      }
    end
  end
  describe "#hosts" do
    it {
      RSpec.stub(:configuration).and_return(Bogus_hosts.new())
      subject.hosts
    }
  end
end

class Bogus_hosts
  def hosts
    ['big', 'little']
  end
end
