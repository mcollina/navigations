# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/shared_page_spec'
require 'navigations'

include Navigations

class DummyController < ApplicationController
end

describe StaticPage do

  before(:each) do
    @instance = StaticPage.new
  end

  it "should have a controller accessor" do
    @instance.should respond_to(:controller)
    @instance.should respond_to(:controller=)

    @instance.controller.should be_nil
    @instance.controller = "DummyController" # the class name
    @instance.controller.should == DummyController

    @instance.controller = "Hello World"
    lambda {
      @instance.controller
    }.should raise_error
  end

  it "should have a name accessor" do
    @instance.should respond_to(:name=)

    @instance.name.should be_nil
    @instance.name = "Hello World"
    @instance.name.should == "Hello World"

    lambda {
      @instance.name = Object.new
    }.should raise_error(ArgumentError)
  end

  it "should have an current? method" do
    @instance.controller = "DummyController"

    @instance.should be_current(DummyController.new)
    @instance.should_not be_current(ApplicationController.new)

    controller = mock "Controller"
    controller.should_receive(:kind_of?).with(Class).and_return(true)
    controller.should_receive(:name).and_return("DummyController")

    @instance.should be_current(controller)
  end

  it "should have a link accessor" do
    @instance.should respond_to(:link=)

    @instance.link = "hello world"
    @instance.link(mock "Obj").should == "hello world"
  end

  it "should have a link_to_eval accessor" do
    @instance.should respond_to(:link_to_eval)
    @instance.should respond_to(:link_to_eval=)

    @instance.link_to_eval = "hello world"
    @instance.link_to_eval.should == "hello world"
  end
  
  it "should eval the 'link_to_eval' when calling :link with an object" do
    class MyClass
      attr_accessor :var
    end

    @instance.link_to_eval = "var"
    
    obj = MyClass.new
    obj.var = "hello world"

    lambda {      
      @instance.link(obj).should == obj.var
    }.should_not raise_error
  end

  it "should have a translatable_name accessor" do
    @instance.should respond_to(:translatable_name)
    @instance.should respond_to(:translatable_name=)

    @instance.translatable_name = "hello world"
    @instance.translatable_name.should == "hello world"
  end

  it "should call correctly I18n.t when handling translatable names" do
    I18n.should_receive(:t).with(:"hello").and_return("hello world")
    @instance.translatable_name = :"hello"
    @instance.name.should == "hello world"
  end

  it "should alias :t_name with :translatable_name" do
    @instance.should respond_to(:t_name)
    @instance.should respond_to(:t_name=)

    @instance.t_name = "hello world"
    @instance.translatable_name.should == "hello world"

    @instance.translatable_name = "booh"
    @instance.t_name.should == "booh"
  end

  it { @instance.should respond_to(:visible_block) }

  it "should allow to specify a block that will be called to check " +
    "if this page is visible" do
    
    obj = mock "Object"

    dummy = mock "Dummy"
    dummy.should_receive(:visible?).with(obj).twice.and_return(true,false)

    @instance.visible_block do |o|
      dummy.visible? o
    end
    
    @instance.should be_visible(obj)
    @instance.should_not be_visible(obj)
  end

  it { @instance.should respond_to(:check_path?) }

  it "shouldn't check the path as default" do
    @instance.check_path?.should be_false
  end

  it "should check the path if there isn't a controller but a link" do

    @instance.link = "/a/path"
    @instance.check_path?.should be_true

    controller = mock "Controller"
    request = mock "Request"
    controller.should_receive(:request).twice.and_return(request)
    request.should_receive(:path).and_return("/a/path", "/another/path")

    @instance.current?(controller).should be_true
    @instance.current?(controller).should be_false
  end

  it "should check the path if there isn't a controller but a link to eval" do

    @instance.link_to_eval = "a_method"

    @instance.check_path?.should be_true

    controller = mock "Controller"
    request = mock "Request"
    controller.should_receive(:a_method).twice.and_return("/a/path")
    controller.should_receive(:request).twice.and_return(request)
    request.should_receive(:path).and_return("/a/path", "/another/path")

    @instance.current?(controller).should be_true
    @instance.current?(controller).should be_false
  end

  it "shouldn't check the path if there is a Controller" do
    @instance.controller = DummyController
    @instance.check_path?.should be_false
  end

  it { @instance.should respond_to(:link_options) }

  it { @instance.should respond_to(:link_options=) }

  it "should have no link options as defaults" do
    @instance.link_options.should == {}
  end

  it "should store additional link options" do
    @instance.link_options[:hello] = "world"
    @instance.link_options[:hello].should == "world"

    options = mock "Options"
    @instance.link_options = options
    @instance.link_options.should == options
  end

  it { @instance.should respond_to(:current_block) }

  it "should allow to specify a block that will be called to check " +
    "if this page is current" do

    obj = mock "Object"

    dummy = mock "Dummy"
    dummy.should_receive(:current?).with(obj).twice.and_return(true,false)

    @instance.current_block do |o|
      dummy.current? o
    end

    @instance.should be_current(obj)
    @instance.should_not be_current(obj)
  end

  it { @instance.should respond_to(:link_block) }

  it "should allow to specify a block that will be called to build the link" do
    obj = mock "Object"

    dummy = mock "Dummy"
    dummy.should_receive(:build_link).with(obj).twice.and_return("a","b")

    @instance.link_block do |o|
      dummy.build_link o
    end

    @instance.link(obj).should == "a"
    @instance.link(obj).should == "b"
  end

  it { @instance.should respond_to(:subpage) }

  it "should allow to specify a subpage through the subpage method" do
    @instance.subpage do |page|
      page.should be_kind_of(StaticPage)
    end
    @instance.subpages.should_not be_empty
  end
end

describe StaticPage, " (initalized)" do

  it_should_behave_like "a navigable page"

  before(:each) do
    @instance = StaticPage.new
    @instance.name = "Hello World"
    @instance.link = "a link"
  end
end