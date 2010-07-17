# this file is auto-loaded by RDoc
unless defined?(::Hanna)
  libdir = File.expand_path('../..', __FILE__)
  unless $LOAD_PATH.include?(libdir)
    # found in installed gems
    name = File.basename(File.dirname(libdir))
    version = name.sub!(/-([^-]+)$/, '') && $1
    # activate self
    gem name, version
  end
  require 'hanna'
end