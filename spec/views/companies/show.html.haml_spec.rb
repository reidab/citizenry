require 'spec_helper'

describe "companies/show.html.erb" do
  before(:each) do
    @company = assign(:company, stub_model(Company))
  end

  it "renders attributes in <p>" do
    render
  end
end
