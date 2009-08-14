# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

require 'navigations'

include Navigations

describe Navigable do
  before(:each) do
    @klass = Class.new
    @klass.send(:include,Navigable)
  end

  it { @klass.should respond_to(:navigator) }

  it "should have a Navigator object inside the :navigator attribute" do
    @klass.navigator.should_not be_nil
    @klass.navigator.should be_kind_of(Navigator)
  end

  it "should inherit the Navigable inclusion when subclassing an inclusing class" do
    subclass = Class.new(@klass)
    subclass.included_modules.should be_include(Navigable)
  end

  it "should add a navigator method to the inclusing class object calling " +
    "the class method" do
    obj = @klass.new
    obj.should respond_to(:navigator)
    obj.navigator.should == @klass.navigator
  end

  it "should add a check class method" do
    @klass.should respond_to(:check)
  end

  it "should add a check class method to its subclasses" do
    subclass = Class.new(@klass)
    subclass.should respond_to(:check)
  end

  it "should add a check_model class method" do
    @klass.should respond_to(:check_model)
  end

  it "should add a check_model class method to its subclasses" do
    subclass = Class.new(@klass)
    subclass.should respond_to(:check_model)
  end

  describe "check class method" do
    it "should accept a name and creates a name? instance method" do
      @klass.check :long_name
      instance = @klass.new
      instance.should respond_to(:long_name?)
    end

    it "should creates a name? instance method that checks the presence
        of an instance variable with the specified name" do
      @klass.check :object
      @klass.send(:attr_accessor, :object)
      instance = @klass.new
      instance.should_not be_object
      instance.object = "hello"
      instance.should be_object
    end

    it "should creates a name? instance method that execute custum code if the
       variable is specified" do
      @klass.check :object, "a_method"
      @klass.send(:attr_accessor, :object)
      instance = @klass.new
      instance.should_not be_object
      instance.object = "hello"
      instance.should_receive(:a_method).and_return(true)
      instance.should be_object
    end
  end

  describe "check_model class method" do
    it "should accept a name and creates a name? instance method" do
      @klass.check :long_name
      instance = @klass.new
      instance.should respond_to(:long_name?)
    end

    it "should creates a name? instance method that checks the presence " +
        "of an instance variable with the specified name and is not a new record" do
      @klass.check_model :object
      @klass.send(:attr_accessor, :object)
      instance = @klass.new
      instance.should_not be_object
      model = mock "Object"
      instance.object = model
      model.should_receive(:new_record?).and_return(true)
      instance.should_not be_object
      model.should_receive(:new_record?).and_return(false)
      instance.should be_object
    end
  end
end

