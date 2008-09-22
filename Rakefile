#
# This can be made cleaner by using the relative gem.
#
require File.join(File.dirname(__FILE__), "lib/hanna/rdoc_version")

require 'echoe'

Echoe.new('hanna') do |p|
  p.version = '0.1.4'
  
  p.summary = "An RDoc template that rocks"
  p.description = "Hanna is an RDoc template that scales. It's implemented in Haml, making its source clean and maintainable. It's built with simplicity, beauty and ease of browsing in mind."
  
  p.author = 'Mislav Marohnić'
  p.email  = 'mislav.marohnic@gmail.com'
  p.url    = 'http://github.com/mislav/hanna'
  
  p.executable_pattern = ['bin/hanna']
  p.has_rdoc = false
  p.runtime_dependencies = []
  p.runtime_dependencies << ['rdoc', Hanna::RDOC_VERSION_REQUIREMENT]
  p.runtime_dependencies << ['haml', '~> 2.0']
  p.runtime_dependencies << ['rake', '~> 0.8.2']
end
