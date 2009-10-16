module Hanna

  VERSION = '0.1.12'

  # The version of RDoc that Hanna should use
  RDOC_VERSION = '2.3.0'
  RDOC_VERSION_REQUIREMENT = "~> #{RDOC_VERSION}"

  # Load the correct version of RDoc
  def self.require_rdoc(terminate = true)
    begin
      gem 'rdoc', RDOC_VERSION_REQUIREMENT
    rescue Gem::LoadError
      $stderr.puts "Hanna requires the RDoc #{RDOC_VERSION} gem"
      exit 1 if terminate
    end 
  end

end
