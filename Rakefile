desc "builds the gem"
task :gem do
  system %(gem build hanna.gemspec)
end

# probably should replace this
task :install => [:gem] do
  sh "gem install hanna*.gem"
end

# We do the following so that RDoc will pick up our plugin now, and also in
# any subshells.
path = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift path
ENV['RUBYLIB'] = begin
  libs = ENV['RUBYLIB'] || ''
  libs = libs.split(File::PATH_SEPARATOR)
  libs << path
  libs.join(File::PATH_SEPARATOR)
end

gemspec = eval(File.read('hanna.gemspec'))

require 'rdoc/task'
RDoc::Task.new do |t|
  t.rdoc_dir = 'doc'
  t.options.push('-f', 'hanna')
  t.main = Dir['README*'].first
  t.rdoc_files.include(*gemspec.files)
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