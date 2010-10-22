require "spec_helper"

describe ResourcesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/resources" }.should route_to(:controller => "resources", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/resources/new" }.should route_to(:controller => "resources", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/resources/1" }.should route_to(:controller => "resources", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/resources/1/edit" }.should route_to(:controller => "resources", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/resources" }.should route_to(:controller => "resources", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/resources/1" }.should route_to(:controller => "resources", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/resources/1" }.should route_to(:controller => "resources", :action => "destroy", :id => "1")
    end

  end
end
