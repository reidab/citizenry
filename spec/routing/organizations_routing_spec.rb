require "spec_helper"

describe OrganizationsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/organizations" }.should route_to(:controller => "organizations", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/organizations/new" }.should route_to(:controller => "organizations", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/organizations/1" }.should route_to(:controller => "organizations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/organizations/1/edit" }.should route_to(:controller => "organizations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/organizations" }.should route_to(:controller => "organizations", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/organizations/1" }.should route_to(:controller => "organizations", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/organizations/1" }.should route_to(:controller => "organizations", :action => "destroy", :id => "1")
    end

  end
end
