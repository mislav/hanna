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

    template('index.haml', 'index.html') do |index|
      index.vars.page_title = @options.title
      index.vars.page_encoding = @options.charset
    
      index.vars.files = @files
      index.vars.methods = @methods
      index.vars.classes = @classes
      index.vars.main_page = find_main_page
    end
    
    template('styles.sass', 'styles.css').write!
  end
  
  protected
  
  def find_main_page
    main = if @options.main_page 
      @files.find { |f| f.full_name == @options.main_page }
    else
      @files.find { |f| f.name =~ /^README(\.|$)/i }
    end
    
    if main
      def main.path    # hack to fix relative linking when
        http_url(nil)  # this file is rendered in index.html
      end
    end
    return main
  end
  
  private
  
  def template(*names)
    tm = Template.new(@template_dir, @output_dir)
    tm.set_target names.pop
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
