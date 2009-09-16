unless defined?(Hanna) or defined?(RDoc)
  require 'rubygems/doc_manager'
  require 'rubygems/requirement'
  require 'hanna/rdoc_version'

  class << Gem::DocManager
    alias load_rdoc_without_version_constraint load_rdoc

    # overwrite load_rdoc to load the exact version of RDoc that Hanna works with
    def load_rdoc
      requirement = Gem::Requirement.create Hanna::RDOC_VERSION_REQUIREMENT
      
      begin
        gem 'rdoc', requirement.to_s
      rescue Gem::LoadError
        # ignore
      end

      # call the original method
      load_rdoc_without_version_constraint

      unless requirement.satisfied_by? rdoc_version
        raise Gem::DocumentError, "ERROR: RDoc version #{requirement} not installed"
      end
    end
  end
end
