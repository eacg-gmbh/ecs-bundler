# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification...
  # see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = 'ecs_bundler'
  gem.homepage = 'http://github.com/eacg-gmbh/ecs-bundler'
  gem.license = 'MIT'
  gem.summary = %(Module for Bundler allowing the transfer of package dependencies to ECS)
  gem.description = %(Module for Bundler allowing the transfer of package dependencies to ECS for further legal and vulnerability analysis. See https://ecs.eacg.de for a detailed service description.)
  gem.email = 'prizrack13@mail.ru'
  gem.authors = ['Anatolii Varanytsia']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

desc 'Code coverage detail'
task :simplecov do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task default: :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ecs-bundler #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
