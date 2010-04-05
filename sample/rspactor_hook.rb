require 'rspactor/listener'

RSpactor::Listener.new(:relative_paths => true) do |files|
  if files.size == 1 and files.first =~ /\.sass$/
    system "rake sample:css"
  elsif files.any? { |f| (f.index('lib/hanna') || f.index('sample/source')) == 0 }
    system "rake sample:doc"
  end
end.start(Dir.pwd)
