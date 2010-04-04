# Hanna -- a better RDoc template

Hanna is an RDoc template that scales. It's implemented in Haml, making the sources clean
and readable. It's built with simplicity, beauty and ease of browsing in mind.

To install Hanna:

    $ gem install hanna

The template was created by [Mislav][] and since then has seen contributions from:

1. [Tony Strauss](http://github.com/DesigningPatterns), who participated from the early
   start by making fixes and enhancements for the template;
2. [Hongli Lai](http://blog.phusion.nl/) with nifty search functionality for methods.

[Visit the wiki][wiki] for more info.


## Usage

There is a command-line tool installed with the Hanna gem:

    $ hanna --help

This is a wrapper over `rdoc` and it forwards all the parameters to it. Manual usage
would require specifying Hanna as a template when invoking RDoc on the command-line:

    $ rdoc --format hanna
    
An alternative is to set the `RDOCOPT` environment variable:

    RDOCOPT="--format hanna"

This will make RDoc always use Hanna unless it is explicitly overridden.

Another neat trick is to put the following line in your .gemrc:

    rdoc: "--format hanna"

This will make RubyGems use Hanna when generating documentation for installed gems.

### Rake task

For repeated generation of API docs, it's better to set up a Rake task. Rake ships
with a predefined class that works with Rdoc:

    require 'rake/rdoctask'
    
    Rake::RDocTask.new do |doc|
      doc.title = 'Here be documentation'
      doc.main = 'README.rdoc'
      doc.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
      doc.rdoc_dir = 'doc'
      doc.options << '--format=hanna'
    end


### Generating documentation for installed gems

You can generate documentation for installed gems with the `--gem` option.
For instance, to generate docs for ActionPack:

    $ [sudo] hanna --gem actionpack -v 2.3.5

You need sudo if your gems directory is not user-writeable. This command gets translated to:

    $ gem rdoc actionpack -v 2.3.5 --no-ri --rdoc --overwrite

To generate docs for **all** gems installed on the system, use `hanna --gem all`.
Careful; that might take a *long* while. Still, existing docs are not overwritten,
meaning you can continue where you left off.


## You can help

I think of Hanna as the first RDoc template that's actually _maintainable_. Template parts
are neatly organized in separate files and Haml/Sass ensure that everything is kept clean.

Fork it, hack away.


[wiki]: http://wiki.github.com/mislav/hanna/ "Hanna wiki"
[mislav]: http://mislav.uniqpath.com/ "Mislav Marohnić"
