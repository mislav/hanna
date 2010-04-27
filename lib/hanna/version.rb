class Hanna
  VERSION = '0.2.pre'
  RDOC_VERSION = '2.5.8'
  RDOC_VERSION_REQUIREMENT = "~> #{RDOC_VERSION}"

  def self.activate_rdoc_gem
    begin
      gem 'rdoc', RDOC_VERSION_REQUIREMENT
    rescue Gem::LoadError
      $stderr.puts "Error: Hanna requires the RDoc #{RDOC_VERSION} gem"
      $stderr.puts "  [sudo] gem install rdoc -v '#{RDOC_VERSION_REQUIREMENT}'"
      exit 1
    end 
  end
end
