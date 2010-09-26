require "spec_helper"

describe CompaniesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/companies" }.should route_to(:controller => "companies", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/companies/new" }.should route_to(:controller => "companies", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/companies/1" }.should route_to(:controller => "companies", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/companies/1/edit" }.should route_to(:controller => "companies", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/companies" }.should route_to(:controller => "companies", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/companies/1" }.should route_to(:controller => "companies", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/companies/1" }.should route_to(:controller => "companies", :action => "destroy", :id => "1")
    end

  end
end
