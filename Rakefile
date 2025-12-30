# frozen_string_literal: true

require "bundler/gem_tasks"

task :default => :spec

desc "Run tests"
task :spec do
  # No tests yet
  puts "No tests defined yet"
end

desc "Install gem locally"
task :install do
  sh "gem build safer-agent.gemspec"
  sh "gem install safer-agent-*.gem"
end

desc "Clean built gems"
task :clean do
  sh "rm -f *.gem"
end
