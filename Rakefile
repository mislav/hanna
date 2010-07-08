desc "builds the gem"
task :gem do
  system %(gem build hanna.gemspec)
end

# probably should replace this
task :install => [:gem] do
  sh "gem install hanna*.gem"
end
