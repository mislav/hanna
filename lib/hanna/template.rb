require 'hanna'
require 'haml'
require 'sass'
require 'ostruct'
require 'hanna/template_helpers'

class Hanna
  class TemplateValues < OpenStruct
    include TemplateHelpers
    public :binding
    undef :methods
  end
  
  class Template
    def initialize(base_dir)
      @base_dir = base_dir
      @templates = []
    end
    
    def vars
      @vars ||= TemplateValues.new
    end
  
    def load_template(*names)
      content = names.inject('') { |all, name| all << File.read(@base_dir + name) }
      extension = names.first =~ /\.(\w+)$/ && $1

      @templates << silence_warnings do
        case extension
        when 'sass'
          Sass::Engine.new(content)
        when 'haml'
          Haml::Engine.new(content, :format => :html4, :filename => names.join(','))
        else
          content
        end
      end
    end
  
    def write(io)
      io.write render
    rescue
      $stderr.puts "error writing to #{io.inspect}"
      raise
    end
  
    protected
  
    def render
      @templates.reverse.inject(nil) do |previous, template|
        case template
        when Haml::Engine
          silence_warnings do
            template.to_html(vars.binding { previous })
          end
        when Sass::Engine
          silence_warnings do
            template.to_css
          end
        when String
          ERB.new(template).result(vars.binding { previous })
        else
          raise "don't know how to handle templates of class #{template.class.name.inspect}"
        end
      end
    end
  
    private
  
    def silence_warnings
      saved, $-w = $-w, false
    
      begin
        yield
      ensure
        $-w = saved
      end
    end
  end 
end