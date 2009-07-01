require 'lib/hanna/version'

desc "generates .gemspec file"
task :gemspec do
  spec = Gem::Specification.new do |p|
    p.name = 'hanna'
    p.version = Hanna::VERSION

    p.summary     = "An RDoc template that scales"
    p.description = "Hanna is an RDoc implemented in Haml, making its source clean and maintainable. It's built with simplicity, beauty and ease of browsing in mind."

    p.author = 'Mislav Marohnić'
    p.email  = 'mislav.marohnic@gmail.com'
    p.homepage = 'http://github.com/mislav/hanna'

    p.add_dependency 'rdoc', Hanna::RDOC_VERSION_REQUIREMENT
    p.add_dependency 'haml', '~> 2.0.4'
    p.add_dependency 'rake', '~> 0.8.2'
    
    p.files = FileList.new('Rakefile', '{bin,lib,rdoc,sample}/**/*', 'README*', 'LICENSE*').
                exclude('sample/rhythm.png', 'sample/output/**/*')
    p.executables = Dir['bin/*'].map { |f| File.basename(f) }

    p.rubyforge_project = nil
    p.has_rdoc = false
  end
  
  spec_string = spec.to_ruby
  
  begin
    Thread.new { eval("$SAFE = 3\n#{spec_string}", binding) }.join 
  rescue
    abort "unsafe gemspec: #{$!}"
  else
    File.open("#{spec.name}.gemspec", 'w') { |file| file.write spec_string }
  end
end

namespace :sample do
  task :doc do
    puts "generating sample output"
    files = FileList.new('sample/source/**/*')
    `rm -r sample/output`
    system %(bin/hanna -o sample/output #{files.join(' ')})
  end
  
  task :css do
    puts "regenerating CSS"
    `sass lib/hanna/template_files/styles.sass sample/output/styles.css`
  end
end

task :rspactor do
  system %(ruby -I~/.coral/rspactor/mislav/lib sample/rspactor_hook.rb)
end