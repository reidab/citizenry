require 'spec_helper'

describe "projects/index.html.haml" do
  before(:each) do
    assign(:projects, [
      stub_model(Project,
        :name => "Name",
        :url => "Url",
        :twitter => "Twitter",
        :description => "MyText"
      ),
      stub_model(Project,
        :name => "Name",
        :url => "Url",
        :twitter => "Twitter",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of projects" do
    render
    rendered.should have_selector("tr>td", :content => "Name".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Url".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Twitter".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
  end
end
