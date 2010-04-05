namespace :sample do
  task :doc do
    puts "generating sample output"
    files = FileList.new('sample/source/**/*')
    libdir = File.expand_path('../lib', __FILE__)
    ENV['RUBYOPT'] = "-w -I#{libdir.gsub(' ', '\ ')} #{ENV['RUBYOPT']}"
    exec 'rdoc', '--format', 'hanna', '--all', '--force-update', '-o', 'sample/output', *files
  end
  
  task :css do
    puts "regenerating CSS"
    `sass lib/hanna/template_files/styles.sass sample/output/styles.css`
  end
end

task :rspactor do
  system %(/usr/bin/ruby -I~/.coral/rspactor-mislav/lib sample/rspactor_hook.rb)
end