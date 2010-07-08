# = A better RDoc HTML template
#
# Authors: Mislav Marohnić <mislav.marohnic@gmail.com>
#          Tony Strauss (http://github.com/DesigningPatterns)
#          Michael Granger <ged@FaerieMUD.org>, who had maintained the original RDoc template

require 'pathname'
require 'haml'
require 'sass'
require 'rdoc/rdoc'
require 'rdoc/generator'
require 'hanna/version' unless ::Hanna # meh

class RDoc::Generator::Hanna 
  STYLE            = 'styles.sass'
  LAYOUT           = 'layout.haml'

  INDEX_PAGE       = 'index.haml'
  CLASS_PAGE       = 'page.haml'
  FILE_PAGE        = CLASS_PAGE

  FILE_INDEX       = 'file_index.haml'
  CLASS_INDEX      = 'class_index.haml'
  METHOD_INDEX     = 'method_index.haml'

  CLASS_DIR        = 'classes'
  FILE_DIR         = 'files'

  INDEX_OUT        = 'index.html'
  FILE_INDEX_OUT   = 'fr_file_index.html'
  CLASS_INDEX_OUT  = 'fr_class_index.html'
  METHOD_INDEX_OUT = 'fr_method_index.html'
  STYLE_OUT        = File.join('css', 'style.css')

  # EPIC CUT AND PASTE TIEM NAO -- GG
  RDoc::RDoc.add_generator( self )

  def self::for( options )
    new( options )
  end

  def initialize( options )
    @options = options

    @templatedir = Pathname.new File.join(File.expand_path(File.dirname(__FILE__)), 'template_files')

    @files      = nil
    @classes    = nil
    @methods    = nil
    #@modsort    = nil

    @basedir = Pathname.pwd.expand_path
  end

  def generate( top_levels )
    @outputdir = Pathname.new( @options.op_dir ).expand_path( @basedir )

    @files = top_levels.sort
    @classes = RDoc::TopLevel.all_classes_and_modules.sort
    @methods = @classes.map { |m| m.method_list }.flatten.sort
    #@modsort = get_sorted_module_list( @classes )

    # Now actually write the output
    write_static_files
    generate_indexes
    generate_class_files
    generate_file_files

  rescue StandardError => err
    p [ err.class.name, err.message, err.backtrace.join("\n  ") ]
    raise
  end

  def write_static_files
    css_dir = outjoin('css')

    unless File.directory?(css_dir)
      FileUtils.mkdir css_dir
    end

    File.open(File.join(css_dir, 'style.css'), 'w') { |f| f << Sass::Engine.new(File.read(templjoin(STYLE))).to_css }
  end

  # FIXME refactor
  def generate_indexes
    @main_page_uri = @files.find { |f| f.name == @options.main_page }.path
    File.open(outjoin(INDEX_OUT), 'w') { |f| f << haml_file(templjoin(INDEX_PAGE)).to_html(binding) }

    file_index = haml_file(templjoin(FILE_INDEX))

    values = {
      :files => @files,
      :stylesheet => STYLE_OUT,
      :list_title => "File Index"
    }

    File.open(outjoin(FILE_INDEX_OUT), 'w') { |f| f << with_layout(values) { file_index.to_html(binding, values) } }

    class_index = haml_file(templjoin(CLASS_INDEX))

    values = {
      :classes => @classes,
      :stylesheet => STYLE_OUT,
      :list_title => "Class Index"
    }

    File.open(outjoin(CLASS_INDEX_OUT), 'w') { |f| f << with_layout(values) { class_index.to_html(binding, values) } }
    
    method_index = haml_file(templjoin(METHOD_INDEX))

    values = {
      :methods => @methods,
      :stylesheet => STYLE_OUT,
      :list_title => "Method Index"
    }

    File.open(outjoin(METHOD_INDEX_OUT), 'w') { |f| f << with_layout(values) { method_index.to_html(binding, values) } }
  end

  def generate_file_files
    file_page = haml_file(templjoin(FILE_PAGE))

    # FIXME non-Ruby files
    @files.each do |file|
      path = Pathname.new(file.path)
      stylesheet = Pathname.new(STYLE_OUT).relative_path_from(path.dirname)
      
      values = { 
        :file => file, 
        :stylesheet => stylesheet,
        :classmod => nil, 
        :title => file.base_name, 
        :list_title => nil 
      } 

      result = with_layout(values) { file_page.to_html(binding, :values => values) { file.description } } 

      # FIXME XXX sanity check
      dir = path.dirname
      unless File.directory? dir
        FileUtils.mkdir_p dir
      end

      File.open(outjoin(file.path), 'w') { |f| f << result }
    end
  end

  def with_layout(values)
    layout = haml_file(templjoin(LAYOUT))
    layout.to_html(binding, :values => values) { yield }
  end

  # probably should bring in nokogiri/libxml2 to do this right.. not sure if
  # it's worth it.
  def frame_link(content)
    content.gsub(%r!<a href="http://[^>]*>!).each do |tag|
      a_tag, rest = tag.split(' ', 2)
      rest.gsub!(/target="[^"]*"/, '')
      a_tag + ' target="_top" ' + rest
    end
  end

  def class_dir
    CLASS_DIR
  end

  def file_dir
    FILE_DIR
  end

  def method_missing(sym, *args)
    p [sym, args]
  end

  def h(html)
    CGI::escapeHTML(html)
  end

  # XXX may my sins be not visited upon my sons.
  def render_class_tree(entries, parent=nil)
    namespaces = { }

    entries.sort.inject('') do |out, klass|
      unless namespaces[klass.full_name]
        if parent
          text = '<span class="parent">%s::</span>%s' % [parent.full_name, klass.name]
        else
          text = klass.name
        end

        out << '<li>'

        out << link_to(text, File.join(CLASS_DIR, klass.full_name.split('::')) + '.html')

        if subentries = @classes.select { |x| x.full_name =~ /^#{klass.full_name}::/ }
          subentries.each { |x| namespaces[x.full_name] = true }
          out << "\n<ol>" + render_class_tree(subentries, klass) + "\n</ol>"
        end

        out << '</li>'
      end

      out
    end
  end
    
  def build_javascript_search_index(entries)
    result = "var search_index = [\n"
    entries.each do |entry|
      method_name = entry.name
      module_name = entry.parent_name
      # FIXME link
      html = link_to_method(entry, '')
      result << "  { method: '#{method_name.downcase}', " +
                      "module: '#{module_name.downcase}', " +
                      "html: '#{html}' },\n"
    end
    result << "]"
    result
  end

  def link_to(text, url = nil, classname = nil)
    class_attr = classname ? ' class="%s"' % classname : ''

    if url
        %[<a target="docwin" href="#{url}"#{class_attr}>#{text}</a>]
    elsif classname
        %[<span#{class_attr}>#{text}</span>]
    else
      text
    end
  end

  # +method_text+ is in the form of "ago (ActiveSupport::TimeWithZone)".
  def link_to_method(entry, url = nil, classname = nil)
    method_name = entry.pretty_name
    module_name = entry.parent_name
    link_to %Q(<span class="method_name">#{h method_name}</span> <span class="module_name">(#{h module_name})</span>), url, classname
  end
  
  #########
  protected
  #########

  def outjoin(name)
    File.join(@outputdir, name)
  end

  def templjoin(name)
    File.join(@templatedir, name)
  end

  def haml_file(file)
    Haml::Engine.new(File.read(file), :format => :html4)
  end
end 
