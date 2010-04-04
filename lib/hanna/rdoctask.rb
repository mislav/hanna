require 'rake/rdoctask'

Rake::RDocTask.class_eval do
  alias initialize_without_hanna initialize
  
  def initialize(*args, &block)
    initialize_without_hanna(*args, &block)
    self.rdoc_dir = 'doc' if rdoc_dir == 'html'
    
    before_running_rdoc do
      require 'rdoc'
      warn "Warning: requiring 'hanna/rdoctask' is deprecated. Use 'rake/rdoctask' instead."
      self.options << '--format' << 'hanna'
    end
  end
end
