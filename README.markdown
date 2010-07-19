# Hanna — a better RDoc template

Hanna is an RDoc generator that scales. It's implemented in Haml, making the
sources clean and readable. It's built with simplicity, beauty and ease of
browsing in mind. (See more in [the wiki][wiki].)

Hanna gem is available from [rubygems.org][]:

    gem install hanna

The template was created by [Mislav][] and since then has seen contributions from:

1. [Tony Strauss](http://github.com/DesigningPatterns), who participated from
   the early start and made tons of fixes and enhancements to the template;
2. [Hongli Lai](http://blog.phusion.nl/) with the search filter for methods.
3. [Erik Hollensbe](http://github.com/erikh) a serious refactoring and up to
   date with RDoc 2.5.x.
4. [James Tucker](http://github.com/raggi) minor cleanups for Erik.

## Usage

    rdoc -o doc -f hanna lib/*.rb

An alternative is to set the `RDOCOPT` environment variable:

    RDOCOPT="-f hanna"

This will make RDoc always use Hanna unless it is explicitly overridden.

## Integrating with RubyGems

Another neat trick is to put the following line in your .gemrc, this will make
RubyGems use Hanna for all rdoc generation:

    rdoc: -f hanna

This will make RubyGems use Hanna when generating documentation for installed
gems.

### Rake task

For repeated generation of API docs, it's better to set up a Rake task. Simply
add the hanna format argument to your RDoc::Task options:

    require 'hanna'
    require 'rdoc/task'
    RDoc::Task.new do |rdoc|
      rdoc.options.push '-f', 'hanna'
    end

Tip: you can do this in the Rakefile of your Rails project before running
`rake doc:rails`.

Here is an example of a task for the [rdbi library][rdbi]:

    require 'hanna'
    require 'rdoc/task'
    RDoc::Task.new do |rdoc|
      version = File.exist?('VERSION') ? File.read('VERSION') : ""

      rdoc.options.push '-f', 'hanna'
      rdoc.main = 'README.rdoc'
      rdoc.rdoc_dir = 'rdoc'
      rdoc.title = "RDBI #{version} Documentation"
      rdoc.rdoc_files.include('README*')
      rdoc.rdoc_files.include('lib/**/*.rb')
    end

### Generating documentation for installed gems

The gem comes with a RubyGems plugin that overrides the gem default arguments
to RDoc to use Hanna.

To regenerate documentation for a specific gem, first configure RubyGems to
use Hanna, by adding the following to your .gemrc:

    rdoc: -f  hanna

Now to regenerate documentation for an already installed gem:

    gem rdoc mygem --overwrite

To regenerate documentation for all gems:

    gem rdoc --all --overwrite

To easily browse your newly created documentation, use `gem server`.

## You can help

Don't like something? Think you can design better? (You probably can.)

I think of Hanna as the first RDoc template that's actually _maintainable_.
First thing I have done is converted the original HTML template to Haml and
Sass, cleaning up and removing the (ridiculous amount of) duplication. Also,
the template fragments are now in _separate files_.

Ultimately, I'd like to lose the frameset. Currently that is far from possible
because the whole RDoc HTML Generator is built for frames. Still, that is my
goal.

This is git. Fork it, hack away, tell me about it!


[wiki]: http://github.com/mislav/hanna/wikis/home "Hanna wiki"
[rubygems.org]: http://rubygems.org/ "RubyGems gem server"
[rdbi]: http://github.com/rdbi/rdbi/tree/master/Rakefile
[Mislav]: http://mislav.caboo.se/ "Mislav Marohnić"
