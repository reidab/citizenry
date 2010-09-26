require 'spec_helper'

describe "groups/edit.html.erb" do
  before(:each) do
    @group = assign(:group, stub_model(Group,
      :new_record? => false,
      :name => "MyString",
      :description => "MyText",
      :url => "MyString",
      :mailing_list => "MyString",
      :twitter => "MyString",
      :meeting_info => "MyText"
    ))
  end

  it "renders the edit group form" do
    render

    rendered.should have_selector("form", :action => group_path(@group), :method => "post") do |form|
      form.should have_selector("input#group_name", :name => "group[name]")
      form.should have_selector("textarea#group_description", :name => "group[description]")
      form.should have_selector("input#group_url", :name => "group[url]")
      form.should have_selector("input#group_mailing_list", :name => "group[mailing_list]")
      form.should have_selector("input#group_twitter", :name => "group[twitter]")
      form.should have_selector("textarea#group_meeting_info", :name => "group[meeting_info]")
    end
  end
end
