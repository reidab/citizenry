require 'spec_helper'

describe "companies/edit.html.erb" do
  before(:each) do
    @company = assign(:company, stub_model(Company,
      :new_record? => false
    ))
  end

  it "renders the edit company form" do
    render

    rendered.should have_selector("form", :action => company_path(@company), :method => "post") do |form|
    end
  end
end
