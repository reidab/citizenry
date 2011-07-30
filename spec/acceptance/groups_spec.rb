require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

def setup_groups
  DatabaseCleaner.clean
  @first  = Factory(:group)
  @second = Factory(:group)
  @third  = Factory(:group)
  @groups = [@first, @second, @third]
end

feature "The group index" do
  background do
    setup_groups
  end

  scenario "should list groups" do
    visit groups_path
    page.should have_css "ul.groups.resource_list li", :count => 3
    @groups.each do |group|
      page.should have_content group.name
    end
  end

  scenario "should list groups by tag" do
    @first.tag_list = "veryuniquetag"
    @first.save!

    visit group_path(@first)
    click_link(@first.tags.first.name)
    page.find(".groups.section_header").should have_content @first.tags.first.name.capitalize
    page.should have_content @first.name
  end

  scenario "should display warning when told to paginate by invalid page number" do
    visit groups_path(:page => "asdf")
    page.find("#flash .error").should have_content "paginate"
  end

  scenario "should display warning when told to sort by invalid parameters" do
    visit groups_path(:order => "asdf")
    page.find("#flash .error").should have_content "sort"
  end
end

feature "The group show page" do
  background do
    setup_groups
  end

  scenario "should be able to access a group from the list" do
    visit groups_path
    click_link @first.name
    current_path.should == group_path(@first)
    page.find(".group.single_record").should have_content @first.name
  end

  scenario "should have details" do
    visit group_path(@first)
    record_div = page.find(".group.single_record")
    [:name, :url, :description, :meeting_info].each do |attr|
      record_div.should have_content @first.send(attr)
    end
    page.find('a.mailing_list')[:href].should == @first.mailing_list
  end

  scenario "should show edit and delete links to anonymous users" do
    visit group_path(@first)
    page.should have_selector(".record_actions .edit")
    page.should have_selector(".record_actions .delete")
  end
end

feature "The group delete button" do
  background do
    setup_groups
  end

  scenario "should delete groups" do
    signed_in_as(:user) do
      visit groups_path
      page.should have_content @first.name

      visit group_path(@first)
      click_link "Delete"

      visit groups_path
      page.should_not have_content @first.name
    end
  end

  scenario "should not allow anonymous users to delete groups" do
    visit groups_path
    page.should have_content @first.name

    visit group_path(@first)
    click_link "Delete"

    current_path.should == new_user_session_path

    visit groups_path
    page.should have_content @first.name
  end
end

feature "The new group form" do
  scenario "should allow users to add a group" do
    # where attributes are defined as the things that are actually stored on the group model, not tags or other bits
    signed_in_as(:user) do
      visit new_group_path
      @from_factory = Factory.build(:group)

      within 'form.group' do
        fill_in 'group_name', :with => @from_factory.name
        fill_in 'group_mailing_list', :with => @from_factory.mailing_list
        fill_in 'group_description', :with => @from_factory.description
        fill_in 'group_meeting_info', :with => @from_factory.meeting_info
        fill_in 'group_url', :with => @from_factory.url
        attach_file('group_logo', Rails.root.join('spec', 'acceptance', 'support', 'test_photo.png'))
        click_button 'group_submit'
      end

      page.should have_selector '.single_record.group'
      page.should have_selector 'img.logo'
      page.should have_content @from_factory.name
      page.should have_content @from_factory.description
      page.should have_content @from_factory.meeting_info
      page.should have_content @from_factory.url
      page.find('a.mailing_list')[:href].should == @from_factory.mailing_list
    end
  end

  scenario "should not be accessible to anonymous users" do
    visit new_group_path
    current_path.should == new_user_session_path
  end
end

feature "The group edit form" do
  background do
    setup_groups
  end

  scenario "should not be accessible by anonymous users" do
    visit edit_group_path(@first)

    current_path.should == new_user_session_path
    page.should have_content "sign in"
  end

  scenario "should be accessible to users" do
    signed_in_as(:user) do
      visit edit_group_path(@first)

      current_path.should == edit_group_path(@first)
      page.should have_selector('form.group')
    end
  end

  scenario "should allow editing of a group's attributes" do
    # where attributes are defined as the things that are actually stored on the group model, not tags or other bits
    signed_in_as(:user) do
      visit edit_group_path(@first)

      within 'form.group' do
        fill_in 'group_name', :with => @first.name.reverse
        fill_in 'group_mailing_list', :with => @first.mailing_list.reverse
        fill_in 'group_description', :with => @first.description.reverse
        fill_in 'group_meeting_info', :with => @first.meeting_info.reverse
        fill_in 'group_url', :with => @first.url.reverse
        click_button 'group_submit'
      end

      current_path.should == group_path(@first)
      page.should have_content @first.name.reverse
      page.should have_content @first.description.reverse
      page.should have_content @first.meeting_info.reverse
      page.should have_content @first.url.reverse
      page.find('a.mailing_list')[:href].should == @first.mailing_list.reverse
    end
  end

  scenario "should allow editing of tags" do
    signed_in_as(:user) do
      # Add 'newtag'
      visit edit_group_path(@first)
      within 'form.group' do
        fill_in 'group_tag_list', :with => "newtag"
        click_button 'group_submit'
      end
      page.find(".section.tags").should have_content "newtag"

      # Make sure it shows back up in the edit form
      visit edit_group_path(@first)
      page.find("#group_tag_list").value.should == "newtag"
      
      # Change 'newtag' to 'newertag'
      within 'form.group' do
        fill_in 'group_tag_list', :with => "newertag"
        click_button 'group_submit'
      end
      page.find(".section.tags").should_not have_content "newtag"
      page.find(".section.tags").should have_content "newertag"

      # and finally remove the tag altogether
      visit edit_group_path(@first)
      within 'form.group' do
        fill_in 'group_tag_list', :with => ""
        click_button 'group_submit'
      end
      page.should_not have_selector ".section.tags"
    end
  end

  scenario "should allow editing of technologies" do
    signed_in_as(:user) do
      # Add 'newtechnology'
      visit edit_group_path(@first)
      within 'form.group' do
        fill_in 'group_technology_list', :with => "newtechnology"
        click_button 'group_submit'
      end
      page.find(".section.technologies").should have_content "newtechnology"

      # Make sure it shows back up in the edit form
      visit edit_group_path(@first)
      page.find("#group_technology_list").value.should == "newtechnology"
      
      # Change 'newtechnology' to 'newertechnology'
      within 'form.group' do
        fill_in 'group_technology_list', :with => "newertechnology"
        click_button 'group_submit'
      end
      page.find(".section.technologies").should_not have_content "newtechnology"
      page.find(".section.technologies").should have_content "newertechnology"

      # and finally remove the technology altogether
      visit edit_group_path(@first)
      within 'form.group' do
        fill_in 'group_technology_list', :with => ""
        click_button 'group_submit'
      end
      page.should_not have_selector ".section.technologies"
    end
  end

  scenario "should allow a user to upload a logo" do
    signed_in_as(:user) do
      visit group_path(@first)
      page.should_not have_selector('img.group_logo')

      visit edit_group_path(@first)
      within 'form.group' do
        attach_file('group_logo', Rails.root.join('spec', 'acceptance', 'support', 'test_photo.png'))
        click_button 'group_submit'
      end
      
      page.should have_selector('img.logo')
    end
  end

  scenario "should allow a user to import a logo from the web" do
    pending "not yet implemented"

    FakeWeb.register_uri(:get, "http://example.com/photo.png", 
                         :body => File.read(Rails.root.join('spec', 'acceptance', 'support', 'test_photo.png')))

    signed_in_as(:user) do
      visit group_path(@first)
      page.should_not have_selector('img.group_logo')

      visit edit_group_path(@first)
      within 'form.group' do
        fill_in 'group_logo_import_url', :with => "http://example.com/photo.png"
        click_button 'group_submit'
      end
      
      page.should have_selector('img.logo')
    end
  end
end

