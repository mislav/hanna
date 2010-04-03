require 'haml'
require 'sass'
require 'ostruct'
require 'hanna/template_helpers'

class Hanna
  class TemplateValues < OpenStruct # :nodoc:
    def initialize(*args)
      super
      @content_for = {}
    end
    
    include TemplateHelpers
    public :binding
    undef :methods
  end
  
  # This class handles reading and rendering Haml, Sass or ERB templates.
  class Template
    # Target path to write out the rendered file to (see #write!)
    attr_reader :target
    
    def initialize(base_dir, output_dir)
      @base_dir = base_dir
      @output_dir = output_dir
      @templates = []
    end
    
    # Struct of local variables that will be available in the template
    # at the time of rendering
    def vars
      @vars ||= TemplateValues.new
    end
    
    # Loads one or multiple template files into a template object. Multiple files
    # are concatenated into one object of the same types. Template types are
    # recognized by extension: .haml, .sass and other for ERB templates.
    def load_template(*names)
      content = names.inject('') { |all, name| all << File.read(@base_dir + name) }
      extension = names.first =~ /\.(\w+)$/ && $1

      @templates << silence_warnings do
        case extension
        when 'sass'
          Sass::Engine.new(content)
        when 'haml'
          Haml::Engine.new(content, :format => :html5, :filename => names.join(','))
        else
          content
        end
      end
    end
    
    # Sets the target path relative to <tt>output_dir</tt>
    def target=(file)
      @target = @output_dir + file
    end
    
    # Renders and writes out the resulting content to `target`
    def write!
      target.dirname.mkpath
      
      File.open(@target, 'w') do |file|
        file.write(render)
      end
    rescue
      $stderr.puts "error writing to #{@target}"
      raise
    end
    
    # Renders currenly loaded templates in the reverse order of which they
    # were added by #load_template. This allows one template to wrap the second,
    # acting as a layout.
    def render
      @templates.reverse.inject(nil) do |previous, template|
        context = vars.binding do |*args|
          what = args.first
          what ? vars.content_for(what) : previous
        end
        
        case template
        when Haml::Engine
          silence_warnings do
            template.to_html(context)
          end
        when Sass::Engine
          silence_warnings do
            template.to_css
          end
        when String
          ERB.new(template).result(context)
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