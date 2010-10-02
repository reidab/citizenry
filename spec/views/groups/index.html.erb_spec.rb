require 'spec_helper'

describe "groups/index.html.haml" do
  before(:each) do
    assign(:groups, [
      stub_model(Group,
        :name => "Name",
        :description => "MyText",
        :url => "Url",
        :mailing_list => "Mailing List",
        :twitter => "Twitter",
        :meeting_info => "MyText"
      ),
      stub_model(Group,
        :name => "Name",
        :description => "MyText",
        :url => "Url",
        :mailing_list => "Mailing List",
        :twitter => "Twitter",
        :meeting_info => "MyText"
      )
    ])
  end

  it "renders a list of groups" do
    render
    rendered.should have_selector("tr>td", :content => "Name".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Url".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Mailing List".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Twitter".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
  end
end
