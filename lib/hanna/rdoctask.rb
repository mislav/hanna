require 'rake'
require 'rake/rdoctask'

Rake::RDocTask.class_eval do
  # don't allow it
  undef :external=, :template=
  
  # Create the tasks defined by this task lib.
  def define # :nodoc:
    options << '--format=hanna'
    options << '--charset=UTF-8' if options.grep(/^(--charset\b|-c\b)/).empty?
    
    desc "Build the HTML documentation"
    task name
    
    desc "Force a rebuild of the RDOC files"
    task paste("re", name) => [paste("clobber_", name), name]

    desc "Remove rdoc products" 
    task paste("clobber_", name) do
      rm_r rdoc_dir rescue nil
    end

    task :clobber => [paste("clobber_", name)]
      
    directory @rdoc_dir
    task name => [rdoc_target]
    file rdoc_target => @rdoc_files + [Rake.application.rakefile] do
      require 'hanna/version'
      Hanna::activate_rdoc_gem
      require 'hanna'
      
      options = option_list + @rdoc_files
      options.delete('--inline-source')
      RDoc::RDoc.new.document(options)
    end
    return self
  end
end
