require File.dirname(__FILE__) + "/static_page"
require File.dirname(__FILE__) + "/dynamic_page_factory"

module Navigations
  class Navigator

    attr_reader :name
  
    def initialize(name=:anonymous)
      @pages = []
      @name = name.to_sym
      @contains_factory = false
    end

    def page(page=nil,&block)
      if page.nil? and block.nil?
        raise ArgumentError.new("You should pass a page or a block to Navigator#page.")
      end
      
      page ||= StaticPage.new

      block.call(page) if block
      
      @pages << page
      self
    end

    def page_factory(factory=nil,&block)
      if factory.nil? and block.nil?
        raise ArgumentError.new("You should pass a page_factory or a block to Navigator#page_factory.")
      elsif factory.nil? and not block.nil?
        factory = DynamicPageFactory.new(&block)
      elsif not factory.respond_to?(:expand)
        raise ArgumentError.new("The factory should have an expand method.")
      end

      @pages << factory
      @contains_factory = true
      self
    end

    def pages
      return @pages.clone unless @contains_factory

      pages = @pages.map do |p|
        if p.respond_to? :expand
          p.expand
        else
          p
        end
      end

      pages.flatten!
    end

    def empty?
      @pages.empty?
    end

    def dup
      duplicate = super
      duplicate.instance_variable_set(:@pages, @pages.dup);
      duplicate
    end
  end
end

