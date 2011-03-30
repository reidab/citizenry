require 'rake'
require 'rake/testtask'
begin
  require 'rubygems'
  require 'hanna/rdoctask'
rescue LoadError
  require 'rake/rdoctask'
end

desc 'Default: specs'
task :default => :spec

require 'spec/rake/spectask'
desc "Run all specs in spec directory (excluding plugin specs)"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end