require 'lib/hanna/version'

Gem::Specification.new do |gem|
  gem.name = 'hanna'
  gem.version = Hanna::VERSION
  
  gem.summary = "An RDoc template that scales"
  gem.description = "Hanna is an RDoc implemented in Haml, making its source clean and maintainable. It's built with simplicity, beauty and ease of browsing in mind."
  
  gem.files = Dir['Rakefile', '{bin,lib,rails,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files`.split("\n")
  gem.executables = Dir['bin/*'].map { |f| File.basename(f) }
  
  gem.add_dependency 'rdoc', Hanna::RDOC_VERSION_REQUIREMENT
  gem.add_dependency 'haml', '~> 2.2.8'
  gem.add_dependency 'rake', '~> 0.8.2'
  
  gem.email = 'mislav.marohnic@gmail.com'
  gem.homepage = 'http://github.com/mislav/' + gem.name
  gem.authors = ['Mislav Marohnić']
  
  gem.has_rdoc = false
  gem.rubyforge_project = nil
end