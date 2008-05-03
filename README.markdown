# Hanna -- a better RDoc template

Hanna is an RDoc template that scales. It's implemented in Haml, making the
sources clean and readable. It's built with simplicity, beauty and ease of
browsing in mind.

Hanna was made by [Mislav][] and is available from [GitHub][]:

    gem install mislav-hanna

After that you have three options. You can use the command-line tool:

    hanna -h

For repeated generation of API docs, it's better to set up a Rake task. Here is
an example for [will_paginate][]:

    # instead of 'rake/rdoctask':
    require 'hanna/rdoctask'
    
    desc 'Generate RDoc documentation for the will_paginate plugin.'
    Rake::RDocTask.new(:rdoc) do |rdoc|
      rdoc.rdoc_files.include('README.rdoc', 'LICENSE', 'CHANGELOG').
        include('lib/**/*.rb').
        exclude('lib/will_paginate/named_scope*').
        exclude('lib/will_paginate/array.rb').
        exclude('lib/will_paginate/version.rb')
      
      rdoc.main = "README.rdoc" # page to start on
      rdoc.title = "will_paginate documentation"
      
      rdoc.rdoc_dir = 'doc' # rdoc output folder
      rdoc.options << '--webcvs=http://github.com/mislav/will_paginate/tree/master/'
    end
    
Either way, it's the same as using RDoc.

The last thing you can do with Hanna is generate documentation for installed
gems. This is a replacement for the "gem rdoc" command.

    [sudo] hanna --gems haml will_paginate

## A work in progress

Hanna is far from done, but it is the first RDoc template that's actually
_maintainable_.  First thing I have done is converted the original HTML
template to Haml and Sass, cleaning up and removing the (ridiculous amount of)
duplication.

Also, the template fragments are now in _separate files_. You would have
fainted if you seen how it was before. (It's really no wonder why there are no
other RDoc templates around ... save one: [Allison][].)

Ultimately, I'd like to lose the frameset. Currently that is far from possible
because the whole RDoc HTML Generator is built for frames. Still, that is my
goal.

## You can help

Don't like something? Think you can design better? (You probably can.)

This is git. I welcome all submissions towards my goal.


[GitHub]: http://gems.github.com/ "GitHub gem source"
[will_paginate]: http://github.com/mislav/will_paginate
[Mislav]: http://mislav.caboo.se/ "Mislav Marohnić"
[Allison]: http://blog.evanweaver.com/files/doc/fauna/allison/ "A modern, pretty RDoc template"
