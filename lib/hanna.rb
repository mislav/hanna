require 'pathname'
require 'fileutils'

require 'rdoc/rdoc'
require 'rdoc/generator'
require 'rdoc/generator/markup'

class RDoc::Generator::Hanna
  
	RDoc::RDoc.add_generator(self)
	
	def self.for(options)
	  new(options)
	end
	
	def initialize(options)
		@options = options
    
    template_files = File.join(File.dirname(__FILE__), 'hanna', 'template_files')
		@template_dir = Pathname.new(template_files).expand_path
		@base_dir = Pathname.pwd.expand_path
	end
	
	def generate(top_levels)
	  @output_dir = Pathname.new(@options.op_dir).expand_path(@base_dir)

		@files = top_levels.sort
		@classes = RDoc::TopLevel.all_classes_and_modules.sort
		@methods = @classes.map { |m| m.method_list }.flatten.sort
    # @modsort = get_sorted_module_list( @classes )

		p @files
		p @classes
		p @methods
	end
	
end
