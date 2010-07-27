desc "builds the gem"
task :gem do
  system %(gem build hanna.gemspec)
end

# probably should replace this
task :install => [:gem] do
  sh "gem install hanna*.gem"
end

ENV['RUBYOPT'] = (ENV['RUBYOPT']||'') + ' -Ilib'

require 'rdoc/task'
RDoc::Task.new do |t|
  t.rdoc_dir = 'doc'
  t.options.push('-f', 'hanna')
  t.main = Dir['README*'].first
  t.rdoc_files.include(*eval(File.read('hanna.gemspec')).files)
  t.rdoc_files.exclude('Rakefile')
end

desc "Generate then open docs"
task :docs => :rerdoc do
  case RUBY_PLATFORM
  when /mswin|mingw/
    sh "start", "doc/index.html"
  when /darwin/
    sh "open", "doc/index.html"
  else
    sh "firefox", "doc/index.html"
  end
end