require 'spec_helper'

describe "resources/show.html.erb" do
  before(:each) do
    @resource = assign(:resource, stub_model(Resource,
      :name => "Name",
      :url => "Url",
      :description => "MyText",
      :category => "Category"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Name".to_s)
    rendered.should contain("Url".to_s)
    rendered.should contain("MyText".to_s)
    rendered.should contain("Category".to_s)
  end
end
