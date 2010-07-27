Gem::Specification.new do |gem|
  gem.name    = 'hanna'
  gem.version = eval(File.read('lib/hanna.rb')[/^\s+VERSION\s+=\s+(.*)$/, 1])
  gem.date    = Time.now.strftime('%Y-%m-%d')
  
  gem.summary = "An RDoc template that scales"
  gem.description = "Hanna is an RDoc implemented in Haml, making its source clean and maintainable. It's built with simplicity, beauty and ease of browsing in mind."
  
  gem.files = Dir['Rakefile', 'lib/**/*', 'README*', 'LICENSE*']
  
  gem.add_dependency 'rdoc', '~> 2.5.9'
  gem.add_dependency 'haml', '~> 2.2.8'
  gem.add_dependency 'rake', '~> 0.8.2'
  
  gem.email = 'mislav.marohnic@gmail.com'
  gem.homepage = 'http://github.com/mislav/' + gem.name
  gem.authors = ['Mislav Marohnić']
  
  gem.has_rdoc = false
  gem.rubyforge_project = nil
end
