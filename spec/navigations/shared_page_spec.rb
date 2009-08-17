# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe "a navigable page", :shared => true do

  it { @instance.should respond_to(:current?) }

  it { @instance.should respond_to(:build_link) }

  it { @instance.should respond_to(:name) }

  it { @instance.should respond_to(:visible?) }

  it "should be visible or not" do
    visible = @instance.visible?(Object.new)

    if visible
      visible.should === true
    else
      visible.should === false
    end
  end

  it "shouldn't be current with a random object" do
    controller = mock "Controller"
    request = mock "Request"
    controller.should_receive(:request).any_number_of_times.and_return(request)
    request.should_receive(:path).any_number_of_times.and_return("/a/strange/path")
    @instance.should_not be_current(controller)
  end

  it "should have a link_options method that returns an hash" do
    @instance.should respond_to(:link_options)
    @instance.link_options.should be_kind_of(Hash)
  end

  it "should have a subpages method that returns an array" do
    @instance.should respond_to(:subpages)
    @instance.subpages.should be_kind_of(Array)
  end

  it { @instance.should respond_to(:has_subpages?) }
end

