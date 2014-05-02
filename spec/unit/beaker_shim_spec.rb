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

  describe "#puppet_module_install_on" do

    shared_context "puppet_module_context" do
      let(:hosts) { hosts_for_context ['/etc/puppetlabs/puppet/modules'] }
    end

    shared_examples "puppet_module_examples" do
      include_context "puppet_module_context"
      it {
        Dir.stub(:glob).and_return(should_be_list.zip(should_not_be_list).flatten.select { |i| !i.nil? })
        host = hosts[0]
        should_be_list.each do |item|
          subject.should_receive(:scp_to).with(host, "./#{item}", "/etc/puppetlabs/puppet/modules/bogusMod/#{item}").once
        end
        should_not_be_list.each do |item|
          subject.should_not_receive(:scp_to).with(host, "./#{item}", anything())
        end
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
    it {
      hosts = hosts_for_context ['/etc/puppetlabs/puppet/modules']
      subject.stub(:hosts).and_return(hosts)
      opts = { :source => './', :module_name => 'bogusMod' }
      subject.stub(:puppet_module_install_on).with(hosts, opts)
      subject.puppet_module_install opts
    }
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
