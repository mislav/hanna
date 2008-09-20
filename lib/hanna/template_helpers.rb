require 'yaml'
require 'cgi'

module Hanna
  module TemplateHelpers
    protected

    def link_to(text, url = nil, classname = nil)
      class_attr = classname ? %[ class="#{classname}"] : ''
      
      if url
        %[<a href="#{url}"#{class_attr}>#{text}</a>]
      elsif classname
        %[<span#{class_attr}>#{text}</span>]
      else
        text
      end
    end

    # We need to suppress warnings before calling into HAML because
    # HAML has lots of uninitialized instance variable accesses.
    def silence_warnings
      save = $-w
      $-w = false
      
      begin
        yield
      ensure
        $-w = save
      end
    end
    module_function :silence_warnings

    def debug(text)
      "<pre>#{h YAML::dump(text)}</pre>"
    end

    def h(html)
      CGI::escapeHTML(html)
    end

    def methods_from_sections(sections)
      sections.inject(Hash.new {|h, k| h[k] = []}) do |methods, section|
        section['method_list'].each do |ml|
          methods["#{ml['type']} #{ml['category']}".downcase].concat ml['methods']
        end if section['method_list']
        methods
      end
    end

    def make_class_tree(entries)
      entries.inject({}) do |tree, entry|
        if entry['href']
          leaf = entry['name'].split('::').inject(tree) do |branch, klass|
            branch[klass] ||= {}
          end
          leaf['_href'] = entry['href']
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
  end
end
