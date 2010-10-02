require 'spec_helper'

describe "companies/index.html.haml" do
  before(:each) do
    assign(:companies, [
      stub_model(Company),
      stub_model(Company)
    ])
  end

  it "renders a list of companies" do
    render
  end
end
