require 'spec_helper'

describe "projects/edit.html.erb" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :new_record? => false,
      :name => "MyString",
      :url => "MyString",
      :twitter => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit project form" do
    render

    rendered.should have_selector("form", :action => project_path(@project), :method => "post") do |form|
      form.should have_selector("input#project_name", :name => "project[name]")
      form.should have_selector("input#project_url", :name => "project[url]")
      form.should have_selector("input#project_twitter", :name => "project[twitter]")
      form.should have_selector("textarea#project_description", :name => "project[description]")
    end
  end
end
