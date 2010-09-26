require 'spec_helper'

describe "organizations/index.html.erb" do
  before(:each) do
    assign(:organizations, [
      stub_model(Organization,
        :name => "Name",
        :url => "Url",
        :twitter => "Twitter",
        :description => "MyText"
      ),
      stub_model(Organization,
        :name => "Name",
        :url => "Url",
        :twitter => "Twitter",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of organizations" do
    render
    rendered.should have_selector("tr>td", :content => "Name".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Url".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Twitter".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
  end
end
