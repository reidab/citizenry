require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "The front page" do
  scenario "should render" do
    visit root_path
    page.should have_content "awesome"
  end
end
