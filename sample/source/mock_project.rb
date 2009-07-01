# A Mock Project!
#
# You guessed it — this is all your fake goodiness right here, baby.
module MockProject
  # FunkyClass is the base of all funky.
  #
  # Everything cool in the world is a subclass of this.
  class FunkyClass
    # funkiness level
    attr_reader :level
    
    # source of all foo!
    attr_accessor :footastic_setting
    
    include EnterpriseProtocol
    include Enumerable
    
    # defines target for REST requests
    API_URL = 'http://mislav.uniqpath.com/'
    
    # While creating funky instances, be careful when you choose
    # the level of funkiness
    def initialize(funkiness_level = 3)
      @level = funkiness_level
    end
    
    # … and for my next miracle …
    def turn_water_into_funk
      return :funk
    end
    
    alias dance turn_water_into_funk
    
    def not_documented
      # intentionally not documented
    end
    
    # this method has multiple usages
    #
    # :call-seq:
    #   multiple_usages(foo, options = {})
    #   multiple_usages(foo, options, bar = nil)
    def multiple_usages(*args)
    end
    
    # this method yields a block
    def each
      yield foo, bar
    end
  end
  
  def self.version
    '0.0.1'
  end
  
  # some booring module
  module EnterpriseProtocol # :nodoc:
    def be_enterprisey
      sleep 20
    end
  end
end