require 'spec_helper'

describe "companies/new.html.erb" do
  before(:each) do
    assign(:company, stub_model(Company,
      :new_record? => true
    ))
  end

  it "renders new company form" do
    render

    rendered.should have_selector("form", :action => companies_path, :method => "post") do |form|
    end
  end
end
