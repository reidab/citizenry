require File.dirname(__FILE__) + '/../spec_helper'

describe AuthenticationsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "create action should render new template when model is invalid" do
    Authentication.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Authentication.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(authentications_url)
  end

  it "destroy action should destroy model and redirect to index action" do
    authentication = Authentication.first
    delete :destroy, :id => authentication
    response.should redirect_to(authentications_url)
    Authentication.exists?(authentication.id).should be_false
  end
end
