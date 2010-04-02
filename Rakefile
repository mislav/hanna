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