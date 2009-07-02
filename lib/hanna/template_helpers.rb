require 'yaml'
require 'cgi'

class Hanna
  module TemplateHelpers
    def content_for(what, text = nil, &block)
      if text or block_given?
        @content_for[what.to_sym] = text || capture_haml(&block)
      else
        @content_for[what.to_sym]
      end
    end
    
    protected

    def link_to(text, url = nil, classname = nil)
      class_attr = classname ? %[ class="#{classname}"] : ''
      
      if url
        %[<a href="#{url}"#{class_attr}>#{text}</a>]
      else
        %[<span#{class_attr}>#{text}</span>]
      end
    end
    
    # +method_text+ is in the form of "ago (ActiveSupport::TimeWithZone)".
    def link_to_method(method_text, url = nil, classname = nil)
      method_text =~ /\A(.+) \((.+)\)\Z/
      method_name, module_name = $1, $2
      link_to %Q(<span class="method_name">#{h method_name}</span> <span class="module_name">(#{h module_name})</span>), url, classname
    end
    
    def relative_path(file)
      if path_to_base and !path_to_base.empty?
        "#{path_to_base}/#{file}"
      else
        file.to_s
      end
    end

    def debug(text)
      "<pre>#{h YAML::dump(text)}</pre>"
    end

    def h(html)
      CGI::escapeHTML(html)
    end
    
    # +entries+ is an array of hashes, each which has a "name" and "href" element.
    # An entry name is in the form of "ago (ActiveSupport::TimeWithZone)".
    # +entries+ must be already sorted by name.
    def build_javascript_search_index(entries)
      result = "var search_index = [\n"
      entries.each do |entry|
        entry[:name] =~ /\A(.+) \((.+)\)\Z/
        method_name, module_name = $1, $2
        html = link_to_method(entry[:name], entry[:href])
        result << "  { method: '#{method_name.downcase}', " <<
                      "module: '#{module_name.downcase}', " <<
                      "html: '#{html}' },\n"
      end
      result << "]"
      result
    end

    def make_class_tree(classes)
      classes.inject({}) do |tree, klass|
        if path = klass.path
          leaf = klass.full_name.split('::').inject(tree) do |branch, mod|
            branch[mod] ||= {}
          end
          leaf['_href'] = path
        end
        tree
      end
    end

    def render_class_tree(tree, parent = nil)
      parent = parent + '::' if parent
      tree.keys.sort.inject('') do |out, name|
        unless name == '_href'
          subtree = tree[name]
          text = parent ? %[<span class="parent">#{parent}</span>#{name}] : name
          out << '<li>'
          out << (subtree['_href'] ? link_to(text, subtree['_href']) : %[<span class="nodoc">#{text}</span>])
          if subtree.keys.size > 1 || (subtree.keys.size == 1 && !subtree['_href'])
            out << "\n<ol>" << render_class_tree(subtree, parent.to_s + name) << "\n</ol>"
          end
          out << '</li>'
        end
        out
      end
    end
    
    # remove extra whitespace in <pre> tags
    def sanitize_code_blocks(text)
      text.gsub(/<pre>(.+?)<\/pre>/m) do
        code = $1.sub(/^ *\n/, '').rstrip
        indent = code.gsub(/\n\s*\n/, "\n").scan(/^ */).map{ |i| i.size }.min
        code.gsub!(/^#{' ' * indent}/, '') if indent > 0
        
        "<pre>#{code}</pre>"
      end
    end
    
    def group_methods(methods_by_type)
      RDoc::Context::TYPES.inject([]) do |grouped_methods, type|
        for visibility in RDoc::Context::VISIBILITIES
          if show_private or visibility == :public
            method_group = methods_by_type[type][visibility]
            grouped_methods << method_group unless method_group.empty?
          end
        end
        grouped_methods
      end
    end
    
    def method_attributes(method)
      attrs = { :id => method.aref, :class => "#{method.visibility} #{method.type}" }
      attrs[:class] << ' alias' if method.is_alias_for
      attrs
    end
    
    def show_include(inc)
      unless String === inc.module
        link_to inc.module.full_name, klass.aref_to(inc.module.path), 'module'
      else
        haml_tag :span, inc.name, :class => 'module'
      end
    end
    
    def extract_main_heading(text)
      if text.sub!(/^\s*<h1>(.+?)<\/h1>\s*/, '')
        self.page_title = $1
      end
      text
    end
  end
end
