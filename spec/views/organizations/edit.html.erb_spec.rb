require 'spec_helper'

describe "organizations/edit.html.erb" do
  before(:each) do
    @organization = assign(:organization, stub_model(Organization,
      :new_record? => false,
      :name => "MyString",
      :url => "MyString",
      :twitter => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit organization form" do
    render

    rendered.should have_selector("form", :action => organization_path(@organization), :method => "post") do |form|
      form.should have_selector("input#organization_name", :name => "organization[name]")
      form.should have_selector("input#organization_url", :name => "organization[url]")
      form.should have_selector("input#organization_twitter", :name => "organization[twitter]")
      form.should have_selector("textarea#organization_description", :name => "organization[description]")
    end
  end
end
