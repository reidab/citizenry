require 'spec_helper'

describe "groups/show.html.erb" do
  before(:each) do
    @group = assign(:group, stub_model(Group,
      :name => "Name",
      :description => "MyText",
      :url => "Url",
      :mailing_list => "Mailing List",
      :twitter => "Twitter",
      :meeting_info => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Name".to_s)
    rendered.should contain("MyText".to_s)
    rendered.should contain("Url".to_s)
    rendered.should contain("Mailing List".to_s)
    rendered.should contain("Twitter".to_s)
    rendered.should contain("MyText".to_s)
  end
end
