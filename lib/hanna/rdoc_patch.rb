require 'rdoc/generator/html'

# RDoc 2.0.0 is inflexible in a way that it doesn't handle absolute paths for
# templates well. We fix that by catching an NameError in load_html_template:
RDoc::Generator::HTML.class_eval do
  private
  alias :load_html_template_original :load_html_template
  
  def load_html_template
    load_html_template_original
  rescue NameError => e
    raise unless e.message.index(@options.template.upcase)
    name = File.basename(@options.template).sub(/\.rb$/, '')
    klass = name.split('_').map{ |n| n.capitalize }.join
    @options.template_class = @template = RDoc::Generator::HTML::const_get(klass)
  end
end
