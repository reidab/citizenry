require 'spec_helper'

describe "projects/new.html.erb" do
  before(:each) do
    assign(:project, stub_model(Project,
      :new_record? => true,
      :name => "MyString",
      :url => "MyString",
      :twitter => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new project form" do
    render

    rendered.should have_selector("form", :action => projects_path, :method => "post") do |form|
      form.should have_selector("input#project_name", :name => "project[name]")
      form.should have_selector("input#project_url", :name => "project[url]")
      form.should have_selector("input#project_twitter", :name => "project[twitter]")
      form.should have_selector("textarea#project_description", :name => "project[description]")
    end
  end
end
