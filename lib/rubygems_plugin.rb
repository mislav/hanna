# TODO  for rubygems 1.3.8, should get Gem.register_plugin(:documtnation,
# 'hanna/rubygems').
# TODO  some way of making this optional.

# Could use Gem.pre_install hooks, but that'd not work for `gem rdoc --all`.

require 'rubygems/doc_manager'
Gem::DocManager.configured_args << '-f' << 'hanna'