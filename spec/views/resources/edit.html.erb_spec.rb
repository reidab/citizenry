require 'spec_helper'

describe "resources/edit.html.erb" do
  before(:each) do
    @resource = assign(:resource, stub_model(Resource,
      :new_record? => false,
      :name => "MyString",
      :url => "MyString",
      :description => "MyText",
      :category => "MyString"
    ))
  end

  it "renders the edit resource form" do
    render

    rendered.should have_selector("form", :action => resource_path(@resource), :method => "post") do |form|
      form.should have_selector("input#resource_name", :name => "resource[name]")
      form.should have_selector("input#resource_url", :name => "resource[url]")
      form.should have_selector("textarea#resource_description", :name => "resource[description]")
      form.should have_selector("input#resource_category", :name => "resource[category]")
    end
  end
end
