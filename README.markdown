# Hanna -- a better RDoc template

Hanna is an RDoc template that scales. It's implemented in Haml, making the
sources clean and readable. It's built with simplicity, beauty and ease of
browsing in mind. (See more in [the wiki][wiki].)

Hanna was made by [Mislav][] and is available from [GitHub][]:

    gem install mislav-hanna


## Usage

After installing, you have several options.
---
Hanna can be used as a normal RDoc template by specifying
  -S -T hanna
to rdoc.  Note that Hanna requires the -S option, which inlines source
code.
---
You can use the command-line tool included in the Hanna gem:

    hanna -h

This is a wrapper over the rdoc script that makes RDoc use the Hanna
template.
---
For repeated generation of API docs, it's better to set up a Rake task.
If you already have an RDocTask set up in your Rakefile, the only thing
you need to change is this:

    # replace this:
    require 'rake/rdoctask'
    # with this:
    require 'hanna/rdoctask'

Tip: you can do this in the Rakefile of your Rails project before running `rake
doc:rails`.

Here is an example of a task for the [will_paginate library][wp]:

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
    
Alternatively, you can use the the standard RDocTask and simply set the
task's +template+ attribute to +hanna+ and append +--inline-source+ to its
options attribute.

A third alternative is to set the +RDOCOPT+ environment variable to

    -T hanna -S

which will make RDoc always use Hanna unless this is overridden on the
command-line.
--
You also can generate documentation for installed gems, which might be more
convenient than the

  gem rdoc

command (with the +RDOCOPT+ environment variable set as above).  For this, do:

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


[wiki]: http://github.com/mislav/hanna/wikis/home "Hanna wiki"
[GitHub]: http://gems.github.com/ "GitHub gem source"
[wp]: http://github.com/mislav/will_paginate
[Mislav]: http://mislav.caboo.se/ "Mislav Marohnić"
[Allison]: http://blog.evanweaver.com/files/doc/fauna/allison/ "A modern, pretty RDoc template"
