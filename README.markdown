# Hanna -- a better RDoc template

Hanna is an RDoc template that scales. It's implemented in Haml, making the sources clean
and readable. It's built with simplicity, beauty and ease of browsing in mind. (See more
in [the wiki][wiki].)

Hanna gem is available from [GitHub][]:

    gem install mislav-hanna

The template was created by [Mislav][] and since then has seen contributions from:

1. [Tony Strauss](http://github.com/DesigningPatterns), who participated from the early
   start and made tons of fixes and enhancements to the template;
2. [Hongli Lai](http://blog.phusion.nl/) with the search filter for methods.


## Usage

There is a command-line tool installed with the Hanna gem:

    hanna -h

This is a wrapper over `rdoc` and it forwards all the parameters to it. Manual usage
would require specifying Hanna as a template when invoking RDoc on the command-line:

    rdoc -o doc --format=hanna lib/*.rb
    
An alternative is to set the `RDOCOPT` environment variable:

    RDOCOPT="-f hanna"

This will make RDoc always use Hanna unless it is explicitly overridden.

Another neat trick is to put the following line in your .gemrc:

    rdoc: --format=hanna

This will make RubyGems use Hanna when generating documentation for installed gems.

### Rake task

For repeated generation of API docs, it's better to set up a Rake task. If you already
have an `RDocTask` set up in your Rakefile, the only thing you need to change is this:

    # replace this:
    require 'rake/rdoctask'
    # with this:
    require 'hanna/rdoctask'

Tip: you can do this in the Rakefile of your Rails project before running `rake doc:rails`.

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

### Generating documentation for installed gems

You can generate documentation for installed gems with the `--gems` flag.
For instance, to generate docs for "actionpack" and "activerecord" type:

    [sudo] hanna --gems actionpack activerecord

If you don't specify any gem names, Hanna is going to generate docs for your
**entire** gem collection. This might take some time.

## You can help

I think of Hanna as the first RDoc template that's actually _maintainable_. Template parts
are neatly organized in separate files and Haml/Sass ensure that everything is kept clean.

This is git. Fork it, hack away, tell me about it!


[wiki]: http://github.com/mislav/hanna/wikis/home "Hanna wiki"
[GitHub]: http://gems.github.com/ "GitHub gem server"
[wp]: http://github.com/mislav/will_paginate/tree/master/Rakefile
[Mislav]: http://mislav.uniqpath.com/ "Mislav Marohnić"
