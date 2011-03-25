require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "The front page" do
  scenario "should render" do
    visit root_path
    page.should have_content "awesome"
  end
end

feature "The 404 page" do
  scenario "should appear when something's not found" do
    DatabaseCleaner.clean
    visit person_path(2001)
    page.should have_content "not found"
    page.should have_selector "#creepy-baby-sloth"
  end
end
