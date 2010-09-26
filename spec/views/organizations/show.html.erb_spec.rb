require 'spec_helper'

describe "organizations/show.html.erb" do
  before(:each) do
    @organization = assign(:organization, stub_model(Organization,
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
