require 'rspactor/listener'

RSpactor::Listener.new do |files|
  if files.size == 1 and files.first =~ /\.sass$/
    system "rake sample:css"
  elsif files.any? { |f| f.index('lib/hanna') || f.index('sample/source') }
    system "rake sample:doc"
  end
end.run(Dir.pwd)