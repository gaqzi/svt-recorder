require 'rspec/core/rake_task'
require './lib/svt/recorder'

desc 'Build the gem'
task :build => :test do
  system 'gem build svt-recorder.gemspec'
end

desc "Release the gem into the wild"
task :release => :build do
  system "git tag v#{SVT::Recorder::VERSION}"
  system 'git push origin'
  system 'git push origin --tags'
  system "gem push svt-recorder-#{SVT::Recorder::VERSION}.gem"
end

desc 'Run all rspec tests'
RSpec::Core::RakeTask.new('test') do |t|
  fail_on_error = true
end
