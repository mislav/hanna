# this file is auto-loaded from Hanna gem by RDoc
if defined?(Rdoc::Rdoc::GENERATORS) and Rdoc::Rdoc::GENERATORS['hanna'].nil?
  load File.join(File.dirname(__FILE__), '..', 'lib', 'hanna', 'version.rb')
  gem 'hanna', Hanna::VERSION
  require 'hanna'
end