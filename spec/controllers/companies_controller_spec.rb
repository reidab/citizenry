require 'spec_helper'

describe CompaniesController do

  def mock_company(stubs={})
    @mock_company ||= mock_model(Company, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all companies as @companies" do
      Company.stub(:all) { [mock_company] }
      get :index
      assigns(:companies).should eq([mock_company])
    end
  end

  describe "GET show" do
    it "assigns the requested company as @company" do
      Company.stub(:find).with("37") { mock_company }
      get :show, :id => "37"
      assigns(:company).should be(mock_company)
    end
  end

  describe "GET new" do
    it "assigns a new company as @company" do
      Company.stub(:new) { mock_company }
      get :new
      assigns(:company).should be(mock_company)
    end
  end

  describe "GET edit" do
    it "assigns the requested company as @company" do
      Company.stub(:find).with("37") { mock_company }
      get :edit, :id => "37"
      assigns(:company).should be(mock_company)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created company as @company" do
        Company.stub(:new).with({'these' => 'params'}) { mock_company(:save => true) }
        post :create, :company => {'these' => 'params'}
        assigns(:company).should be(mock_company)
      end

      it "redirects to the created company" do
        Company.stub(:new) { mock_company(:save => true) }
        post :create, :company => {}
        response.should redirect_to(company_url(mock_company))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved company as @company" do
        Company.stub(:new).with({'these' => 'params'}) { mock_company(:save => false) }
        post :create, :company => {'these' => 'params'}
        assigns(:company).should be(mock_company)
      end

      it "re-renders the 'new' template" do
        Company.stub(:new) { mock_company(:save => false) }
        post :create, :company => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested company" do
        Company.should_receive(:find).with("37") { mock_company }
        mock_company.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :company => {'these' => 'params'}
      end

      it "assigns the requested company as @company" do
        Company.stub(:find) { mock_company(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:company).should be(mock_company)
      end

      it "redirects to the company" do
        Company.stub(:find) { mock_company(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(company_url(mock_company))
      end
    end

    describe "with invalid params" do
      it "assigns the company as @company" do
        Company.stub(:find) { mock_company(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:company).should be(mock_company)
      end

      it "re-renders the 'edit' template" do
        Company.stub(:find) { mock_company(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested company" do
      Company.should_receive(:find).with("37") { mock_company }
      mock_company.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the companies list" do
      Company.stub(:find) { mock_company }
      delete :destroy, :id => "1"
      response.should redirect_to(companies_url)
    end
  end

end
