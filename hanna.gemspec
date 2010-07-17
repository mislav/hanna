# encoding: utf-8
require File.expand_path('../lib/hanna/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'hanna'
  gem.version = Hanna::VERSION
  gem.date    = Time.now.strftime('%Y-%m-%d')
  
  gem.add_dependency 'rdoc', Hanna::RDOC_VERSION_REQUIREMENT
  gem.add_dependency 'haml', '~> 3.0.10'
  
  gem.summary = "An RDoc template that scales"
  gem.description = "Hanna is an RDoc implemented in Haml, making its source clean and maintainable. It's built with simplicity, beauty and ease of browsing in mind."
  
  gem.authors  = ['Mislav Marohnić']
  gem.email    = 'mislav.marohnic@gmail.com'
  gem.homepage = 'http://github.com/mislav/hanna'
  
  gem.rubyforge_project = nil
  gem.has_rdoc = true
  
  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*']
  gem.files &= `git ls-files -z`.split("\0") if `type -t git 2>/dev/null || which git 2>/dev/null` && $?.success?
end
