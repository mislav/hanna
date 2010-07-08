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
  METHOD_LIST_PAGE = 'method_list.haml'
  FILE_PAGE        = CLASS_PAGE
  SECTIONS_PAGE    = 'sections.haml'

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

    generate_index(FILE_INDEX_OUT, FILE_INDEX, 'File', { :files => @files})
    generate_index(CLASS_INDEX_OUT, CLASS_INDEX, 'Class', { :classes => @classes })
    generate_index(METHOD_INDEX_OUT, METHOD_INDEX, 'Method', { :methods => @methods })
  end

  def generate_index(outfile, templfile, index_name, values)
    values.merge!({
      :stylesheet => STYLE_OUT,
      :list_title => "#{index_name} Index"
    })

    index = haml_file(templjoin(templfile))

    File.open(outjoin(outfile), 'w') do |f| 
      f << with_layout(values) do
             index.to_html(binding, values)
           end
    end
  end

  def generate_file_files
    file_page = haml_file(templjoin(FILE_PAGE))
    method_list_page = haml_file(templjoin(METHOD_LIST_PAGE))

    # FIXME non-Ruby files
    @files.each do |file|
      path = Pathname.new(file.path)
      stylesheet = Pathname.new(STYLE_OUT).relative_path_from(path.dirname)
      
      values = { 
        :file => file, 
        :entry => file,
        :stylesheet => stylesheet,
        :classmod => nil, 
        :title => file.base_name, 
        :list_title => nil,
        :description => file.description
      } 

      result = with_layout(values) do 
        file_page.to_html(binding, :values => values) do 
          method_list_page.to_html(binding, values) 
        end
      end

      # FIXME XXX sanity check
      dir = path.dirname
      unless File.directory? dir
        FileUtils.mkdir_p dir
      end

      File.open(outjoin(file.path), 'w') { |f| f << result }
    end
  end

  def generate_class_files
    class_page       = haml_file(templjoin(CLASS_PAGE))
    method_list_page = haml_file(templjoin(METHOD_LIST_PAGE))
    sections_page    = haml_file(templjoin(SECTIONS_PAGE))
    # FIXME refactor

    @classes.each do |klass|
      outfile = classfile(klass)
      stylesheet = Pathname.new(STYLE_OUT).relative_path_from(outfile.dirname)

      values = { 
        :file => klass.path, 
        :entry => klass,
        :stylesheet => stylesheet,
        :classmod => klass.type,
        :title => klass.full_name,
        :list_title => nil,
        :description => klass.description,
        :section => {
          # FIXME linkify
          :classlist => '<ol>' + klass.classes_and_modules.inject('') { |x,y| x << '<li>' + y.name + '</li>' } + '</ol>',
          :constants => klass.constants,
          :aliases   => klass.method_list.select { |x| x.is_alias_for },
          :attributes => klass.attributes,
          :method_list => klass.method_list.select { |x| !x.is_alias_for }
        }
      } 

      result = with_layout(values) do 
        class_page.to_html(binding, :values => values) do 
          method_list_page.to_html(binding, :values => values) +
            sections_page.to_html(binding, :values => values)
        end
      end

      # FIXME XXX sanity check
      dir = outfile.dirname
      unless File.directory? dir
        FileUtils.mkdir_p dir
      end

      File.open(outfile, 'w') { |f| f << result }
    end
  end

  def with_layout(values)
    layout = haml_file(templjoin(LAYOUT))
    layout.to_html(binding, :values => values) { yield }
  end

  def sanitize_code_blocks(text)
    text.gsub(/<pre>(.+?)<\/pre>/m) do
      code = $1.sub(/^\s*\n/, '')
      indent = code.gsub(/\n[ \t]*\n/, "\n").scan(/^ */).map{ |i| i.size }.min
      code.gsub!(/^#{' ' * indent}/, '') if indent > 0

        "<pre>#{code}</pre>"
    end
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

        out << link_to(text, classfile(klass))

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
      html = link_to_method(entry, [classfile(entry.parent), entry.aref].join('#'))
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

  def classfile(klass)
    # FIXME sloooooooow
    Pathname.new(File.join(CLASS_DIR, klass.full_name.split('::')) + '.html')
  end

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
