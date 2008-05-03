require 'yaml'
require 'cgi'

RDoc::TemplatePage.class_eval do
  def write_html_on(io, values)
    result = @templates.reverse.inject(nil) do |previous, template|
      case template
        when Haml::Engine
          template.to_html(get_binding, :values => values) { previous }
        when Sass::Engine
          template.to_css
        when String
          ERB.new(template).result(get_binding(values){ previous })
        when nil
          previous
        else
          raise "don't know how to handle a template of class '#{template.class.name}'"
        end
    end

    io.write result
  rescue
    $stderr.puts "error while writing to #{io.inspect}"
    raise
  end

  protected

  ### View helpers ###

  def link_to(text, url = nil)
    href(url, text)
  end

  def debug(text)
    "<pre>#{h YAML::dump(text)}</pre>"
  end

  def h(html)
    CGI::escapeHTML html
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
      leaf = entry['name'].split('::').inject(tree) do |branch, klass|
        branch[klass] ||= {}
      end
      leaf['_href'] = entry['href']
      tree
    end
  end

  def render_class_tree(tree, parent = nil)
    parent = parent + '::' if parent
    tree.keys.sort.inject('') do |out, name|
      unless name == '_href'
        subtree = tree[name]
        text = parent ? "<span class='parent'>#{parent}</span>#{name}" : name
        out << '<li>'
        out << (subtree['_href'] ? link_to(text, subtree['_href']) : "<span class='class'>#{text}</span>")
        if subtree.keys.size > 1
          out << "\n<ol>" << render_class_tree(subtree, parent.to_s + name) << "\n</ol>"
        end
        out << '</li>'
      end
      out
    end
  end

  private

    def get_binding(values = nil)
      binding
    end
end
