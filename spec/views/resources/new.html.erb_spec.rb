require 'spec_helper'

describe "resources/new.html.erb" do
  before(:each) do
    assign(:resource, stub_model(Resource,
      :new_record? => true,
      :name => "MyString",
      :url => "MyString",
      :description => "MyText",
      :category => "MyString"
    ))
  end

  it "renders new resource form" do
    render

    rendered.should have_selector("form", :action => resources_path, :method => "post") do |form|
      form.should have_selector("input#resource_name", :name => "resource[name]")
      form.should have_selector("input#resource_url", :name => "resource[url]")
      form.should have_selector("textarea#resource_description", :name => "resource[description]")
      form.should have_selector("input#resource_category", :name => "resource[category]")
    end
  end
end
