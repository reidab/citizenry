require "spec_helper"

describe ProjectsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/projects" }.should route_to(:controller => "projects", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/projects/new" }.should route_to(:controller => "projects", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/projects/1" }.should route_to(:controller => "projects", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/projects/1/edit" }.should route_to(:controller => "projects", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/projects" }.should route_to(:controller => "projects", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/projects/1" }.should route_to(:controller => "projects", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/projects/1" }.should route_to(:controller => "projects", :action => "destroy", :id => "1")
    end

  end
end
