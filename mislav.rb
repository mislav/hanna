require 'rdoc/generator/html'
# require 'rdoc/generator/html/one_page_html'
require 'haml'
require 'sass'
require 'yaml'

# = A better RDoc HTML template
#
# Many different kinds of awesome.
#
# == Authors
#
# * Mislav Marohnić <mislav.marohnic@gmail.com>
# * Michael Granger <ged@FaerieMUD.org>
#
# Copyright (c) 2002, 2003 The FaerieMUD Consortium. Some rights reserved.
#
# This work is licensed under the Creative Commons Attribution License. To view
# a copy of this license, visit http://creativecommons.org/licenses/by/1.0/ or
# send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California
# 94305, USA.

module RDoc::Generator::HTML::Mislav
  class << self
    def dir
      @dir ||= File.dirname(__FILE__)
    end

    def file(name)
      path = [name]
      path.unshift 'templates' if name =~ /\.html(\.(erb|haml))?$/
      content = File.read(File.join(dir, *path))

      case name
      when /\.sass$/
        Sass::Engine.new(content)
      when /\.haml$/
        Haml::Engine.new(content)
      else
        content
      end
    end
  end

  STYLE = file('styles.sass')

  CLASS_PAGE = file('class_page.html.haml')
  FILE_PAGE = file('file_page.html.haml')

  BODY = file('layout.html.haml')
  
  METHOD_LIST = file('method_list.html.haml')

  FR_INDEX_BODY = %{FR_INDEX_BODY <%= template_include %>}

  FILE_INDEX = file('file_index.html.erb')
  CLASS_INDEX = FILE_INDEX
  METHOD_INDEX = FILE_INDEX

  INDEX = file('index.html.erb')
end 
