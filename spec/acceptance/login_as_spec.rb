require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "The person's profile" do
  background do
    DatabaseCleaner.clean
    @user   = FactoryGirl.create(:user_with_person)
    @person = @user.person
  end

  scenario "should not provide 'login as this user' normally" do
    visit person_path(@person)

    page.should_not have_css('.login_as_this_user')
  end

  scenario "should allow 'login as this user' when enabled" do
    ApplicationController.stub(:allow_login_as_specific_user?).and_return(true)

    visit person_path(@person)
    find(".login_as_this_user a", :href => authentications_path(:user_id => @user.id)).click

    page.should have_css("#account_box .name a", :text => @person.name)
  end

  scenario "should show failure if trying to login with invalid 'user_id'" do
    # Create a user/person with an ID that we can be certain isn't in the database.
    user   = FactoryGirl.create(:user_with_person)
    person = user.person
    user_id = user.id
    person.destroy
    user.destroy

    ApplicationController.stub(:allow_login_as_specific_user?).and_return(true)

    page.driver.post(authentications_path(:user_id => user_id))
    visit root_path

    page.should_not have_css("#account_box .name")
  end
end

feature "The homepage" do
  background do
    DatabaseCleaner.clean
  end

  scenario "should not provide a 'login as sample user' normally" do
    visit root_path

    page.should_not have_css(".login_as_sample_user")
  end

  scenario "should provide and allow a 'login as sample user' when enabled" do
    ApplicationController.stub(:allow_login_as_specific_user?).and_return(true)

    visit root_path
    find(".login_as_sample_user a").click

    page.should have_css("#account_box .name a", :text => Person.find_sample.name)
  end
end
