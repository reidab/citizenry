require 'spec_helper'

describe "people/show.html.erb" do
  before(:each) do
    @person = assign(:person, stub_model(Person,
      :first_name => "First Name",
      :last_name => "Last Name",
      :email => "Email",
      :twitter => "Twitter",
      :url => "Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("First Name".to_s)
    rendered.should contain("Last Name".to_s)
    rendered.should contain("Email".to_s)
    rendered.should contain("Twitter".to_s)
    rendered.should contain("Url".to_s)
  end
end
