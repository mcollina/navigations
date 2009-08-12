
module Navigations
  class DynamicPageFactory
    def initialize(&block)
      if block.nil?
        raise ArgumentError.new("DynamicPageFactory needs a block.")
      end
      @block = block
    end

    def expand
      @block.call
    end
  end
end
