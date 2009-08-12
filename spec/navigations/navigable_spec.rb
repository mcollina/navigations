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
end

