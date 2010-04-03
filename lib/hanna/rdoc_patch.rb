require 'rdoc/parser'
require 'rdoc/markup/to_html_crossref'

RDoc::Parser::Ruby.class_eval do
  alias broken_extract_call_seq extract_call_seq
  
  # properly extract the call-seq without messing up rest of the comment
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
  # expose the instance variable
  attr_accessor :from_path
end
