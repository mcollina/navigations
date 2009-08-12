module Navigations
  class StaticPage

    attr_accessor :link_to_eval
    
    attr_accessor :translatable_name
    alias :t_name :translatable_name
    alias :t_name= :translatable_name=

    attr_writer :link

    attr_accessor :link_options

    def initialize
      @link_options = Hash.new
      @current_block = nil
      @name = nil
      @translatable_name = nil
      @link = nil
      @link_to_eval = nil
      @link_block = nil
      @subpages = []
    end

    def name=(name)
      unless name.respond_to?(:to_str)
        raise ArgumentError.new("The page name should be a string")
      end
      @name = name
    end

    def name
      if not @name.nil?
        return @name
      elsif not @translatable_name.nil?
        return I18n.t @translatable_name
      end
    end

    def controller
      if @controller.respond_to?(:to_str)
        @controller = eval(@controller.to_str)
        if @controller.kind_of? Class
          validate(@controller)
        else
          raise "The controller should be a class."
        end
      end

      @controller
    end

    def controller=(controller)
      validate(controller)
      @controller = controller
    end

    def current?(current_controller)
      return @current_block.call(current_controller) unless @current_block.nil?

      controller_class = current_controller
      controller_class = controller_class.class unless controller_class.kind_of? Class

      if check_path?
        return link(current_controller) == current_controller.request.path
      else
        return controller_class.name == controller.name #this work even in development mode
      end
    end

    def link(controller)
      if not @link.nil?
        @link
      elsif not @link_block.nil? and not controller.nil?
        @link_block.call(controller)
      elsif not link_to_eval.nil? and not controller.nil?
        eval(link_to_eval, controller.send(:binding))
      else
        nil
      end
    end

    def visible?(controller)
      unless @visible_block.nil?
        @visible_block.call controller
      else
        true
      end
    end

    def visible_block(&block)
      @visible_block = block
    end

    def check_path?
      if (not (@link.nil? and @link_to_eval.nil?)) and controller.nil?
        true
      else
        false
      end
    end

    def current_block(&block)
      @current_block = block
    end

    def link_block(&block)
      @link_block = block
    end

    def subpages
      @subpages
    end

    def has_subpages?
      not @subpages.empty?
    end

    def subpage
      page = StaticPage.new
      yield page
      @subpages << page
    end

    private
    def validate(controller)
      if controller.kind_of?(Class) and not controller.ancestors.include?(ApplicationController)
        raise ArgumentError.new("The controller for the page #{name} should be a class object" +
            " descending from ApplicationController.")
      end
    end
  end
end
