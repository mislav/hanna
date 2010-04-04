require 'pathname'
require 'fileutils'

require 'rdoc/rdoc'
require 'hanna/rdoc_patch'
require 'hanna/parsers'

# In RDoc terms, Hanna is in fact both <em>generator</em> and template.
# The role of an RDoc generator is to render output documentation in a
# certain format when given the raw data that was the result of parsing
# source files.
# 
# The <em>template</em> is only a set of template files in a directory.
# RDoc default generator, Darkfish, allows users to write their own
# template files, which is much easier than writing a complete generator.
# Hanna could not be implemented this way because Darkfish only renders
# ERB templates, while Hanna is written in Haml/Sass.
class Hanna
  
  RDoc::RDoc.add_generator(self)
  
  autoload :Template, 'hanna/template'
  
  # Factory method for getting a generator instance based on rdoc options.
  # Currently equivalent to <tt>Hanna.new(options)</tt>
  def self.for(options)
    new(options)
  end
  
  def class_dir # :nodoc:
    'classes'
  end
  
  def file_dir # :nodoc:
    'files'
  end
  
  def initialize(options)
    @options = options
    # TODO: make template directory configurable
    template_files = File.join(File.dirname(__FILE__), 'hanna', 'template_files')
    @template_dir = Pathname.new(template_files).expand_path
    @base_dir = Pathname.pwd.expand_path
  end
  
  # Does the heavy lifting.
  #
  # RDoc invokes this method with an array of "top_levels", i.e. metadata
  # about files that it parsed.
  def generate(top_levels)
    @output_dir = Pathname.new(@options.op_dir).expand_path(@base_dir)
    
    @files = top_levels.sort
    @main_page = find_main_page
    @text_files = @files.select do |file|
      file != @main_page and file.text_content?
    end
    @classes = RDoc::TopLevel.all_classes_and_modules.select { |mod| mod.document_self }.sort
    @methods = @classes.map { |m| m.method_list }.flatten.sort

    template('index.haml', 'project_index.haml', 'index.html') do |index|
      index.vars.page_title = @options.title
      index.vars.page_type = :main
      index.vars.current_page = @main_page
      index.vars.files = @text_files
      index.vars.methods = @methods
      index.vars.classes = @classes
    end
    
    for klass in @classes
      template('class_module.haml', klass.path) do |tm|
        tm.vars.page_title = klass.full_name
        tm.vars.page_type = :class_module
        tm.vars.klass = klass
      end
    end
    
    for file in @text_files
      template('index.haml', file.path) do |file_page|
        file_page.vars.page_title = file.full_name
        file_page.vars.page_type = :file
        file_page.vars.current_page = file
      end
    end
    
    template('styles.sass', 'styles.css').write!
  end
  
  protected
  
  def find_main_page
    page = if @options.main_page 
      @files.find { |f| f.full_name == @options.main_page }
    else
      @files.find { |f| f.name =~ /\bREADME\b/i } || @files.first
    end
    page.formatter.from_path = '' if page
    page
  end
  
  private
  
  def template(*names)
    tm = Template.new(@template_dir, @output_dir)
    target = names.pop
    tm.target = target
    
    if names.first =~ /\.haml$/
      tm.load_template 'layout.haml'
      
      tm.vars.path_to_base = @output_dir.relative_path_from(tm.target.dirname)
      tm.vars.page_encoding = @options.charset
      tm.vars.show_private = @options.show_all
    end
    
    tm.load_template(*names)
    
    if block_given?
      yield tm
      tm.write!
    else
      return tm
    end
  end
  
end
