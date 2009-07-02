require 'rdoc/parser'

RDoc::Parser::Ruby.class_eval do
  def extract_call_seq(comment, meth) # :nodoc:
    if comment.sub!(/:?call-seq:(.*?)(\Z|\n\s*#?\s*\n)/m, '\2') then
      seq = $1
      seq.gsub!(/^\s*\#\s*/, '')
      meth.call_seq = seq
    end

    meth
  end
end

RDoc::Markup::ToHtmlCrossref.class_eval do
  attr_accessor :from_path
end
  
RDoc::TopLevel.class_eval do
  def description # :nodoc:
    parser == Hanna::MarkdownParser ? @comment : super
  end
end

class Hanna
  class MarkdownParser < RDoc::Parser # :nodoc:

    parse_files_matching(/\.(md(own)?|markdown)$/)

    def initialize(top_level, file_name, content, options, stats)
      super
      require 'bluecloth' unless defined?(::BlueCloth)
    end

    def scan
      @top_level.comment = ::BlueCloth.new(@content).to_html
      @top_level.parser = self.class
      @top_level
    end
  end
end
