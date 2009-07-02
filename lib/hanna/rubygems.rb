require 'rubygems/doc_manager'

class Hanna
  # A set of helpers for using the Gem::DocManager to generate Hanna documentation
  # for installed gems. It is used by <tt>hanna</tt> command-line tool.
  module Rubygems
    # Triggers gem documentation generation. If +gem_names+ is a non-empty array,
    # documentation for specified gems will be generated.
    # If the argument is an empty array, this will generate documentation for
    # <tt>all</tt> installed gems.
    def self.document(gem_names, options = {})
      Gem::DocManager.configured_args = options

      unless gem_names.empty?
        specs = find_gems(gem_names)
      else
        specs = all_installed_gems
        # TODO: prompt user for confirmation
        puts "Hanna is installing documentation for #{specs.size} gem#{specs.size > 1 ? 's' : ''} ..."
      end

      specs.each do |spec|
        Gem::DocManager.new(spec).generate_rdoc
      end
    end
    
    protected
    
    def self.find_gems(names)
      names.inject([]) do |all, name|
        found = Gem::SourceIndex.from_installed_gems.find_name(name)
        spec = found.sort_by {|s| s.version }.last
        all << spec if spec
        all
      end
    end
    
    def self.all_installed_gems
      Gem::SourceIndex.from_installed_gems.inject({}) do |all, pair|
        full_name, spec = pair
        if spec.has_rdoc? and (!all[spec.name] or spec.version > all[spec.name].version)
          all[spec.name] = spec
        end
        all
      end.values
    end
  end
end
