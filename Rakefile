begin
  require 'rspec/core/rake_task'
  RSPEC::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  # rspec not available
end
