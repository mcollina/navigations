module Navigations
  class StaticPage
    
    attr_accessor :translatable_name
    alias :t_name :translatable_name
    alias :t_name= :translatable_name=

    attr_accessor :link_options

    def initialize
      @link_options = Hash.new
      @current_block = nil
      @name = nil
      @translatable_name = nil
      @link_block = nil
      @visible_block = CallableValue.new(true)
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

    def link
      return @link_block.value if @link_block.respond_to? :value
      nil
    end

    def link= link
      @link_block = CallableValue.new(link)
      link
    end
    
    alias :link_to_eval :link

    def link_to_eval= link_to_eval
      @link_block = CallableEvalString.new(link_to_eval)
      link_to_eval
    end

    def current?(current_controller)
      return @current_block.call(current_controller) unless @current_block.nil?

      controller_class = current_controller
      controller_class = controller_class.class unless controller_class.kind_of? Class

      if check_path?
        return build_link(current_controller) == current_controller.request.path
      else
        return controller_class.name == controller.name #this work even in development mode
      end
    end

    def build_link(controller)
      return @link_block.call(controller) if not @link_block.nil? and not controller.nil?
      nil
    end

    def visible?(controller)
      @visible_block.call controller
    end

    def visible_block(&block)
      @visible_block = block
    end

    def visible_method= method_name
      @visible_block = CallableSendMethod.new(method_name)
    end

    def visible_method
      return @visible_block.value if @visible_block.respond_to? :value
      nil
    end

    def check_path?
      @link_block.respond_to? :value and controller.nil?
    end

    def current_block(&block)
      @current_block = block
    end

    def current= current
      @current_block = CallableValue.new(current)
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

    class CallableValue

      attr_accessor :value

      def initialize value
        @value = value
      end

      def call controller
        value
      end
    end

    class CallableEvalString < CallableValue

      def call controller
        eval(value, controller.send(:binding))
      end
    end

    class CallableSendMethod < CallableValue

      def call controller
        controller.send(value)
      end
    end
  end
end
