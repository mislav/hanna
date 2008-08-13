Gem::Specification.new do |s|
  s.name    = 'hanna'
  s.version = '0.1.3'
  s.date    = '2008-05-03'
  
  s.summary = "An RDoc template that rocks"
  s.description = "Hanna is an RDoc template that scales. It's implemented in Haml, making its source clean and maintainable. It's built with simplicity, beauty and ease of browsing in mind."
  
  s.authors  = ['Mislav Marohnić']
  s.email    = 'mislav.marohnic@gmail.com'
  s.homepage = 'http://github.com/mislav/hanna'
  
  s.executables = ['hanna']
  s.has_rdoc = false
  s.add_dependency 'rdoc', ['~> 2.1.0']
  s.add_dependency 'haml', ['~> 2.0']
  
  s.files = %w(README.markdown Rakefile bin bin/hanna lib lib/hanna lib/hanna.rb lib/hanna/hanna.rb lib/hanna/rdoc_patch.rb lib/hanna/rdoctask.rb lib/hanna/template_files lib/hanna/template_files/class_index.haml lib/hanna/template_files/file_index.haml lib/hanna/template_files/index.haml lib/hanna/template_files/layout.haml lib/hanna/template_files/method_list.haml lib/hanna/template_files/page.haml lib/hanna/template_files/sections.haml lib/hanna/template_files/styles.sass lib/hanna/template_helpers.rb lib/hanna/template_page_patch.rb)
end
