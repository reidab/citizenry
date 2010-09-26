require 'spec_helper'

describe "projects/show.html.erb" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => "Name",
      :url => "Url",
      :twitter => "Twitter",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Name".to_s)
    rendered.should contain("Url".to_s)
    rendered.should contain("Twitter".to_s)
    rendered.should contain("MyText".to_s)
  end
end
