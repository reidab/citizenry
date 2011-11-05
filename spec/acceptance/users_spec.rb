require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Users:" do
  background do
    OmniAuth.config.test_mode = true
  end

  scenario "Trying to sign in without an email address should fail usefully" do
    visit sign_in_path
    find("input[name='commit']").click

    page.should have_content I18n.t('errors.messages.blank')
  end

  scenario "A new user should be able to sign in (and out)" do
    signed_in_as(:user) do
      page.should have_css 'form.person'
    end
  end

  scenario "A new user, after signing in, should be able to add themselves to the directory" do
    signed_in_as(:user) do
      page.should have_css 'form.person'
      
      @name = Faker::Name.name
      @location = Faker::Address.city
      @bio = Faker::Company.catch_phrase
      @url = 'http://epdx.org/testperson'
      @tags = 'testtag'
      @technology = 'testtech'

      within 'form.person' do
        fill_in 'person_name', :with => @name
        fill_in 'person_location', :with => @location
        fill_in 'person_bio', :with => @bio
        fill_in 'person_url', :with => @url
        fill_in 'person_tag_list', :with => @tags
        fill_in 'person_technology_list', :with => @technology
        find("input[name='commit']").click
      end

      within '.person.single_record' do
        page.should have_content @name
        page.should have_content @location
        page.should have_content @bio
        page.should have_content @url
        page.should have_content @tags
        page.should have_content @technology
      end
    end
  end

  scenario "An existing user with an unreviewed person should be asked to review their entry" do
    signed_in_as(:user_with_new_person) do
      current_path.should == "/welcome"
      page.should have_content I18n.t('user.welcome.review_details')
      page.find('form.person #person_name').value.should == @user.person.name
    end
  end

  scenario "An existing user with a reviwed person should be shown their user home page." do
    signed_in_as(:user_with_person) do
      current_path.should == '/home'
    end
  end

  scenario "A logged-out user should be forced to sign in when attempting to add a person." do
    visit people_path
    click_link('new_person')
    current_path.should == '/user_sessions/new'
  end

  scenario "A user should be able to add and remove a linked account" do
    OmniAuth.config.mock_auth[:twitter] = {
      'provider' => 'twitter',
      'uid' => 'the_twitterer',
      'user_info' => {}
    }
    
    signed_in_as(:user_with_person) do
      visit home_users_path

      within '#authentications #new_sign_in_data' do
        select 'Twitter', :from => 'sign_in_data_provider'
        find("input[name='commit']").click
      end
      
      page.should have_selector "#twitter_the_twitterer"

      within "#twitter_the_twitterer" do
        click_link I18n.t('button.remove')
      end

      page.should_not have_selector "#twitter_the_twitterer"
    end
  end
end


feature "The user admin page" do
  scenario "should not be accessible to anonymous users" do
    visit users_path
    current_path.should == new_user_session_path
  end

  scenario "should not be accessible to normal users" do
    signed_in_as(:user) do
      visit users_path
      current_path.should == root_path
    end
  end

  scenario "should be accessible to admins" do
    signed_in_as(:admin_user) do
      visit users_path
      current_path.should == users_path
    end
  end
end
