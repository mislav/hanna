require 'rdoc/parser'
require 'rdoc/top_level'

class Hanna
  class ExternalParser < RDoc::Parser # :nodoc:
    class << self
      def uses(name, lib = nil)
        @name = name
        @lib = lib || @name.downcase
      end
      
      def load_dependency
        return if defined? @loaded
        begin
          require @lib unless Object.const_defined?(@name)
          @loaded = true
        rescue LoadError
          warn "failed to load #{@lib.inspect}; #{@name} will not be used"
          @loaded = false
        end
      end
      
      def loaded?
        @loaded
      end
    end
    
    def initialize(*args)
      super
      self.class.load_dependency
    end

    def scan
      @top_level.comment = self.class.loaded?? process : @content
      @top_level.parser = self.class
      @top_level
    end
  end
  
  class MarkdownParser < ExternalParser # :nodoc:
    parse_files_matching(/\.(mk?d|markdown)$/)
    
    uses 'RDiscount'

    def process
      ::RDiscount.new(@content).to_html
    end
  end
  
  class TextileParser < ExternalParser # :nodoc:
    parse_files_matching(/\.textile$/)
    
    uses 'RedCloth'

    def process
      ::RedCloth.new(@content).to_html
    end
  end
  
  module Markup # :nodoc:
    def text_content?
      parser and parser == RDoc::Parser::Simple || parser < ExternalParser
    end

    # skip processing text that's already in HTML format
    def description
      if parser and parser < ExternalParser
        if formatter.class.const_defined? 'CROSSREF_REGEXP'
          @comment.gsub(formatter.class::CROSSREF_REGEXP) do |name|
            formatter.handle_special_CROSSREF(CrossrefToken.new(name))
          end
        else
          @comment
        end
      else
        super
      end
    end
    
    # String wrapper that responds to `text` and returns the string
    class CrossrefToken
      attr_reader :text
      def initialize(text) @text = text end
    end
  end
  
end

RDoc::TopLevel.send(:include, Hanna::Markup)
