require 'rspec/core/rake_task'

task :default => :test

task :spec do
  Rake::Task[':test'].invoke
end

desc 'Run RSpec'
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/unit/*.rb'
#  t.rspec_opts = ['--color']
end
