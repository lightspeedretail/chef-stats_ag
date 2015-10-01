task :default => [:lint, :spec]

namespace :test do
  desc "Run all tests, including all integration tests"
  task :all => [:default, 'kitchen:all']
end

# Linting
require 'foodcritic'
desc ":lint == :foodcritic. Just less typing."
task :lint => [:foodcritic]
FoodCritic::Rake::LintTask.new

# Unit tests
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :test => [:spec]

# Integration tests
begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end
