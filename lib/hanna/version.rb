class Hanna
  VERSION = '0.2.0'
  RDOC_VERSION = '2.4.2'
  RDOC_VERSION_REQUIREMENT = "~> #{RDOC_VERSION}"

  def self.require_rdoc
    begin
      gem 'rdoc', RDOC_VERSION_REQUIREMENT
    rescue Gem::LoadError
      $stderr.puts "Error: Hanna requires the RDoc #{RDOC_VERSION} gem"
      exit 1
    end 
  end
end
