require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

def setup_people
  DatabaseCleaner.clean
  @first_person  = Factory(:person)
  @second_person = Factory(:person)
  @third_person  = Factory(:person)
  @people = [@first_person, @second_person, @third_person]
end

feature "The person index" do
  background do
    setup_people
  end

  scenario "should list people" do
    visit people_path
    page.should have_css "ul.people.resource_list li", :count => 3
    @people.each do |person|
      page.should have_content person.name
    end
  end

  scenario "should list people by tag" do
    @first_person.tag_list = "veryuniquetag"
    @first_person.save!

    visit person_path(@first_person)
    click_link(@first_person.tags.first.name)
    page.find(".people.section_header").should have_content @first_person.tags.first.name.capitalize
    page.should have_content @first_person.name
  end

  scenario "should show the person grid" do
    visit grid_people_path
    page.should have_css "ul.people.resource_grid li", :count => 3
  end

  scenario "should be able to switch between the list and the grid" do
    visit people_path
    page.should have_css "ul.people.resource_list li", :count => 3
    click_link "Grid"
    page.should have_css "ul.people.resource_grid li", :count => 3
    click_link "List"
    page.should have_css "ul.people.resource_list li", :count => 3
  end
end

feature "The person show page" do
  background do
    setup_people
  end

  scenario "should be able to access a person from the list" do
    visit people_path
    click_link @first_person.name
    current_path.should == person_path(@first_person)
    page.find(".person.single_record").should have_content @first_person.name
  end

  scenario "should have details" do
    visit person_path(@first_person)
    record_div = page.find(".person.single_record")
    [:name, :location, :url, :bio].each do |attr|
      record_div.should have_content @first_person.send(attr)
    end
  end

  scenario "should not show edit and delete links to anonymous users" do
    visit person_path(@first_person)
    page.should_not have_selector(".record_actions .edit")
    page.should_not have_selector(".record_actions .delete")
  end

  scenario "should show edit and delete links to a person's owner" do
    signed_in_as(:user_with_person) do
      visit person_path(@user.person)
      page.should have_selector(".record_actions .edit")
      page.should have_selector(".record_actions .delete")
    end
  end

  scenario "should not show edit and delete links for people the user does not own" do
    signed_in_as(:user_with_person) do
      visit person_path(@first_person)
      page.should_not have_selector(".record_actions .edit")
      page.should_not have_selector(".record_actions .delete")
    end
  end

  scenario "should always show edit and delete links to admins" do
    signed_in_as(:admin_user) do
      visit person_path(@first_person)
      page.should have_selector(".record_actions .edit")
      page.should have_selector(".record_actions .delete")
    end
  end
end

feature "The person delete button" do
  background do
    setup_people
  end

  scenario "should allow users to delete themselves" do
    signed_in_as(:user_with_person) do
      @person = @user.person

      visit people_path
      page.should have_content @person.name

      visit person_path(@person)
      click_link "Delete"

      visit people_path
      page.should_not have_content @person.name
    end
  end

  scenario "should allow admins to delete anyone" do
    signed_in_as(:admin_user) do
      visit people_path
      page.should have_content @first_person.name

      visit person_path(@first_person)
      click_link "Delete"

      visit people_path
      page.should_not have_content @first_person.name
    end
  end
end

feature "The person edit form" do
  background do
    setup_people
  end

  scenario "should not be accessible by anonymous users" do
    visit edit_person_path(@first_person)

    current_path.should == new_user_session_path
    page.should have_content "sign in"
  end

  scenario "should be accessible by the person's owner" do
    signed_in_as(:user_with_person) do
      visit edit_person_path(@user.person)

      current_path.should == edit_person_path(@user.person)
      page.should have_selector('form.person')
      page.should_not have_selector('select#person_user_id')
    end
  end

  scenario "should not be accessible by other users than the person's owner" do
    signed_in_as(:user_with_person) do
      visit edit_person_path(@first_person)
      current_path.should == person_path(@first_person)
    end
  end

  scenario "should be accessible to admins (with additional options!)" do
    signed_in_as(:admin_user) do
      visit edit_person_path(@first_person)

      current_path.should == edit_person_path(@first_person)
      page.should have_selector('form.person')
      page.should have_selector('select#person_user_id')
    end
  end

  scenario "should allow editing of a person's attributes" do
    # where attributes are defined as the things that are actually stored on the person model, not tags or other bits
    signed_in_as(:user_with_person) do
      @person = @user.person

      visit edit_person_path(@person)

      within 'form.person' do
        fill_in 'person_name', :with => @person.name.reverse
        fill_in 'person_location', :with => @person.location.reverse
        fill_in 'person_bio', :with => @person.bio.reverse
        fill_in 'person_url', :with => @person.url.reverse
        find("input[name='commit']").click
      end

      current_path.should == person_path(@person)
      page.should have_content @person.name.reverse
      page.should have_content @person.location.reverse
      page.should have_content @person.bio.reverse
      page.should have_content @person.url.reverse
    end
  end

  scenario "should allow editing of a user's email address" do
    signed_in_as(:user_with_person) do
      @person = @user.person

      visit edit_person_path(@person)

      within('form.person') do
        fill_in 'person_user_attributes_email', :with => "unique_email@example.com"
        find("input[name='commit']").click
      end

      current_path.should == person_path(@person)
      visit edit_person_path(@person)

      find("#person_user_attributes_email").value.should == "unique_email@example.com"
    end
  end

  scenario "should allow editing of tags" do
    signed_in_as(:user_with_person) do
      @person = @user.person

      # Add 'newtag'
      visit edit_person_path(@person)
      within 'form.person' do
        fill_in 'person_tag_list', :with => "newtag"
        find("input[name='commit']").click
      end
      page.find(".section.tags").should have_content "newtag"

      # Make sure it shows back up in the edit form
      visit edit_person_path(@person)
      page.find("#person_tag_list").value.should == "newtag"
      
      # Change 'newtag' to 'newertag'
      within 'form.person' do
        fill_in 'person_tag_list', :with => "newertag"
        find("input[name='commit']").click
      end
      page.find(".section.tags").should_not have_content "newtag"
      page.find(".section.tags").should have_content "newertag"

      # and finally remove the tag altogether
      visit edit_person_path(@person)
      within 'form.person' do
        fill_in 'person_tag_list', :with => ""
        find("input[name='commit']").click
      end
      page.should_not have_selector ".section.tags"
    end
  end

  scenario "should allow editing of technologies" do
    signed_in_as(:user_with_person) do
      @person = @user.person

      # Add 'newtechnology'
      visit edit_person_path(@person)
      within 'form.person' do
        fill_in 'person_technology_list', :with => "newtechnology"
        find("input[name='commit']").click
      end
      page.find(".section.technologies").should have_content "newtechnology"

      # Make sure it shows back up in the edit form
      visit edit_person_path(@person)
      page.find("#person_technology_list").value.should == "newtechnology"
      
      # Change 'newtechnology' to 'newertechnology'
      within 'form.person' do
        fill_in 'person_technology_list', :with => "newertechnology"
        find("input[name='commit']").click
      end
      page.find(".section.technologies").should_not have_content "newtechnology"
      page.find(".section.technologies").should have_content "newertechnology"

      # and finally remove the technology altogether
      visit edit_person_path(@person)
      within 'form.person' do
        fill_in 'person_technology_list', :with => ""
        find("input[name='commit']").click
      end
      page.should_not have_selector ".section.technologies"
    end
  end

  scenario "show allow editing of slug" do
    signed_in_as(:user_with_person) do
      person = @user.person

      visit edit_person_path(person)
      within "form.person" do
        fill_in "person_custom_slug_or_friendly_id", :with => "Foo Bar"
        find("input[name='commit']").click
      end

      current_path.should == person_path("foo-bar")

      person.reload
      person.slug.should == "foo-bar"
    end
  end

  scenario "should not allow duplicate slug" do
    Factory.create(:person, :name => "Foo Bar", :custom_slug => "foo-bar")

    signed_in_as(:user_with_person) do
      person = @user.person
      original_slug = person.slug

      visit edit_person_path(person)
      within "form.person" do
        fill_in "person_custom_slug_or_friendly_id", :with => "Foo Bar"
        find("input[name='commit']").click
      end

      page.find(".record_errors").should have_content "Custom slug is not unique"
      current_path.should == person_path(original_slug)

      person.reload
      person.slug.should_not == "foo-bar"
    end
  end

  scenario "should allow the user to upload a photo" do
    signed_in_as(:user_with_person) do
      @person = @user.person

      visit person_path(@person)
      page.should_not have_selector('img.person_photo')

      visit edit_person_path(@person)
      within 'form.person' do
        attach_file('person_photo', Rails.root.join('spec', 'acceptance', 'support', 'test_photo.png'))
        find("input[name='commit']").click
      end
      
      page.should have_selector('img.person_photo')
    end
  end

  scenario "should allow the user to import a photo from the web" do
    FakeWeb.register_uri(:get, "http://example.com/photo.png", 
                         :body => File.read(Rails.root.join('spec', 'acceptance', 'support', 'test_photo.png')))

    signed_in_as(:user_with_person) do
      @person = @user.person

      visit person_path(@person)
      page.should_not have_selector('img.person_photo')

      visit edit_person_path(@person)
      within 'form.person' do
        fill_in 'person_photo_import_url', :with => "http://example.com/photo.png"
        find("input[name='commit']").click
      end
      
      page.should have_selector('img.person_photo')
    end
  end
end

