require 'spec_helper'

describe PeopleController do

  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all people as @people" do
      Person.stub(:all) { [mock_person] }
      get :index
      assigns(:people).should eq([mock_person])
    end
  end

  describe "GET show" do
    it "assigns the requested person as @person" do
      Person.stub(:find).with("37") { mock_person }
      get :show, :id => "37"
      assigns(:person).should be(mock_person)
    end
  end

  describe "GET new" do
    it "assigns a new person as @person" do
      Person.stub(:new) { mock_person }
      get :new
      assigns(:person).should be(mock_person)
    end
  end

  describe "GET edit" do
    it "assigns the requested person as @person" do
      Person.stub(:find).with("37") { mock_person }
      get :edit, :id => "37"
      assigns(:person).should be(mock_person)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created person as @person" do
        Person.stub(:new).with({'these' => 'params'}) { mock_person(:save => true) }
        post :create, :person => {'these' => 'params'}
        assigns(:person).should be(mock_person)
      end

      it "redirects to the created person" do
        Person.stub(:new) { mock_person(:save => true) }
        post :create, :person => {}
        response.should redirect_to(person_url(mock_person))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved person as @person" do
        Person.stub(:new).with({'these' => 'params'}) { mock_person(:save => false) }
        post :create, :person => {'these' => 'params'}
        assigns(:person).should be(mock_person)
      end

      it "re-renders the 'new' template" do
        Person.stub(:new) { mock_person(:save => false) }
        post :create, :person => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested person" do
        Person.should_receive(:find).with("37") { mock_person }
        mock_person.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :person => {'these' => 'params'}
      end

      it "assigns the requested person as @person" do
        Person.stub(:find) { mock_person(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:person).should be(mock_person)
      end

      it "redirects to the person" do
        Person.stub(:find) { mock_person(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(person_url(mock_person))
      end
    end

    describe "with invalid params" do
      it "assigns the person as @person" do
        Person.stub(:find) { mock_person(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:person).should be(mock_person)
      end

      it "re-renders the 'edit' template" do
        Person.stub(:find) { mock_person(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested person" do
      Person.should_receive(:find).with("37") { mock_person }
      mock_person.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the people list" do
      Person.stub(:find) { mock_person }
      delete :destroy, :id => "1"
      response.should redirect_to(people_url)
    end
  end

end
