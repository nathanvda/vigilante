# encoding: UTF-8
require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'
require 'rdoc/task'

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Vigilante'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "vigilante"
    gem.summary = %Q{Context-based, db-backed authorisation for your rails3 apps}
    gem.description = %Q{Vigilante is a db-backed authorisation, completely configurable and dynamic; where permissions can be limited to extents.}
    gem.email = "nathan@dixis.com"
    gem.homepage = "http://github.com/vigilante"
    gem.authors = ["Nathan Van der Auwera"]
    # gem.add_development_dependency "rails", ">= 3.0.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)


task :default => :spec
