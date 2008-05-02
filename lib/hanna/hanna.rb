require 'haml'
require 'sass'
require 'rdoc/generator/html'
require 'hanna/template_page_patch'

# = A better RDoc HTML template
#
# Many different kinds of awesome.
#
# Author: Mislav Marohnić <mislav.marohnic@gmail.com>
# Based on the work of Michael Granger <ged@FaerieMUD.org>

module RDoc::Generator::HTML::Hanna
  class << self
    def dir
      @dir ||= File.join File.dirname(__FILE__), 'template_files'
    end

    def read(name)
      content = File.read(File.join(dir, name))
      extension = name =~ /\.(\w+)$/ && $1

      case extension
      when 'sass'
        Sass::Engine.new(content)
      when 'haml'
        Haml::Engine.new(content)
      else
        content
      end
    end
  end

  STYLE = read('styles.sass')

  CLASS_PAGE  = read('class_page.haml')
  FILE_PAGE   = read('file_page.haml')
  METHOD_LIST = read('method_list.haml')

  FR_INDEX_BODY = BODY = read('layout.haml')

  FILE_INDEX   = read('file_index.haml')
  CLASS_INDEX  = read('class_index.haml')
  METHOD_INDEX = FILE_INDEX

  INDEX = read('index.haml')
end 
