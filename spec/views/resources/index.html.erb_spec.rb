require 'spec_helper'

describe "resources/index.html.erb" do
  before(:each) do
    assign(:resources, [
      stub_model(Resource,
        :name => "Name",
        :url => "Url",
        :description => "MyText",
        :category => "Category"
      ),
      stub_model(Resource,
        :name => "Name",
        :url => "Url",
        :description => "MyText",
        :category => "Category"
      )
    ])
  end

  it "renders a list of resources" do
    render
    rendered.should have_selector("tr>td", :content => "Name".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Url".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Category".to_s, :count => 2)
  end
end
