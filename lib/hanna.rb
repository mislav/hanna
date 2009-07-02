require 'pathname'
require 'fileutils'

require 'rdoc/rdoc'
require 'rdoc/generator'
require 'rdoc/generator/markup'

require 'hanna/template'

class Hanna
  
  RDoc::RDoc.add_generator(self)
  
  def self.for(options)
    new(options)
  end
  
  def class_dir
    'classes'
  end
  
  def file_dir
    'files'
  end
  
  # STYLE = read('styles.sass')
  # 
  # CLASS_PAGE  = read('page.haml')
  # FILE_PAGE   = CLASS_PAGE
  # METHOD_LIST = read('method_list.haml', 'sections.haml')
  # 
  # FR_INDEX_BODY = BODY = read('layout.haml')
  # 
  # FILE_INDEX   = read('file_index.haml')
  # CLASS_INDEX  = read('class_index.haml')
  # METHOD_INDEX = read('method_index.haml')
  # 
  # INDEX = read('index.haml')
  
  def initialize(options)
    @options = options
    # TODO: make template directory configurable
    template_files = File.join(File.dirname(__FILE__), 'hanna', 'template_files')
    @template_dir = Pathname.new(template_files).expand_path
    @base_dir = Pathname.pwd.expand_path
  end
  
  def generate(top_levels)
    @output_dir = Pathname.new(@options.op_dir).expand_path(@base_dir)
    
    # TODO: figure out what's with the duplicates?!
    @files = top_levels.sort
    @classes = RDoc::TopLevel.all_classes_and_modules.sort
    @methods = @classes.map { |m| m.method_list }.flatten.sort
    # @modsort = get_sorted_module_list( @classes )

    template('index.haml', 'index.html') do |index|
      index.vars.page_title = @options.title
      index.vars.page_encoding = @options.charset
    
      index.vars.files = @files
      index.vars.methods = @methods
      index.vars.classes = @classes
      index.vars.main_page = find_main_page
    end
    
    for klass in @classes
      template('class_module.haml', klass.path) do |tm|
        tm.vars.page_encoding = @options.charset
        tm.vars.page_title = klass.full_name
        tm.vars.klass = klass
        tm.target.dirname.mkpath
      end
    end
    
    template('styles.sass', 'styles.css').write!
  end
  
  protected
  
  def find_main_page
    if @options.main_page 
      @files.find { |f| f.full_name == @options.main_page }
    else
      @files.find { |f| f.name =~ /^README(\.|$)/i }
    end
  end
  
  private
  
  def template(*names)
    tm = Template.new(@template_dir, @output_dir)
    target = names.pop
    tm.set_target target

    depth = target.scan('/').size
    tm.vars.path_to_base = depth > 0 ? (['..'] * depth).join('/') : nil
    
    tm.load_template 'layout.haml' if names.first =~ /\.haml$/
    tm.load_template *names
    
    if block_given?
      yield tm
      tm.write!
    else
      return tm
    end
  end
  
end
