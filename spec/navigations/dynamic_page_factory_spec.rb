# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'
require 'navigations'

include Navigations

describe DynamicPageFactory do

  def mock_page(name)
    mock name
  end

  before(:each) do
    @first = mock_page("First")
    @second = mock_page("Second")
    @instance = DynamicPageFactory.new do
      [@first,@second]
    end
  end

  it { @instance.should respond_to(:expand) }

  it "should have an expand method that runs the original block" do
    @instance.expand.should == [@first,@second]
  end

  it "shouldn't cache the expand results" do
    first_ary = @instance.expand
    @instance.expand.should === first_ary
  end

  it "should check whether the block isn't nil" do
    lambda {
      DynamicPageFactory.new
    }.should raise_error(ArgumentError)
  end
end

