require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "The front page" do
  scenario "should render" do
    visit root_path
    page.should have_content I18n.t('site.index.home_to')
  end
end

feature "The 404 page" do
  scenario "should appear when something's not found" do
    DatabaseCleaner.clean
    visit person_path(2001)
    page.should have_content I18n.t('site.err404.text')
    page.should have_selector "#creepy-baby-sloth"
  end
end
