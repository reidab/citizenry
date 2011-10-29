# For raw invocations, run something like: COVERAGE=1 rspec spec/models/person_spec.rb

desc "Run simplecov code coverage tool"
task :simplecov do
  ENV["COVERAGE"] = "true"
  Rake::Task["spec"].invoke
end
