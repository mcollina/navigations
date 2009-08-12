# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'
require 'navigations'

include Navigations

describe Repository do

  it "should have an instances method" do
    Repository.should respond_to(:instances)
    Repository.instances.should be_kind_of(Array)
  end

  it "should have a get method" do
    Repository.should respond_to(:get)

    navigator = Repository.get(:hello)
    navigator.should_not be_nil

    navigator.name.should == :hello
  end

  it "should have a get method that yeild the navigator" do
    Repository.should respond_to(:get)

    navigator = Repository.get(:hello)
    other = nil
    Repository.get(:hello) { |n| other = n }
    other.should == navigator
  end

  it "should have a get method that returns always the same navigator" do
    Repository.should respond_to(:get)
    Repository.get(:hello).should == Repository.get(:hello)
  end
end

