unless defined?(::Hanna) or defined?(::RDoc)
  require 'rubygems/doc_manager'
  require 'rubygems/requirement'

  # define the Hanna namespace to prevent actions of rubygems_plugin from older versions
  module ::Hanna; end

  class << Gem::DocManager
    alias load_rdoc_without_version_constraint load_rdoc

    # overwrite load_rdoc to load the exact version of RDoc that Hanna works with
    def load_rdoc
      unless defined? ::Hanna::VERSION
        load File.expand_path(File.join(File.dirname(__FILE__), 'hanna', 'version.rb'))
      end

      Hanna::require_rdoc(false) # don't terminate if failed

      # call the original method
      load_rdoc_without_version_constraint
      requirement = Gem::Requirement.create Hanna::RDOC_VERSION_REQUIREMENT

      unless requirement.satisfied_by? rdoc_version
        raise Gem::DocumentError, "ERROR: RDoc version #{requirement} not installed"
      end
    end
  end
end
