require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

def setup_projects
  DatabaseCleaner.clean
  @first  = Factory(:project)
  @second = Factory(:project)
  @third  = Factory(:project)
  @projects = [@first, @second, @third]
end

feature "The project index" do
  background do
    setup_projects
  end

  scenario "should list projects" do
    visit projects_path
    page.should have_css "ul.projects.resource_list li", :count => 3
    @projects.each do |project|
      page.should have_content project.name
    end
  end

  scenario "should list projects by tag" do
    @first.tag_list = "veryuniquetag"
    @first.save!

    visit project_path(@first)
    click_link(@first.tags.first.name)
    page.find(".projects.section_header").should have_content @first.tags.first.name.capitalize
    page.should have_content @first.name
  end
end

feature "The project show page" do
  background do
    setup_projects
  end

  scenario "should be able to access a project from the list" do
    visit projects_path
    click_link @first.name
    current_path.should == project_path(@first)
    page.find(".project.single_record").should have_content @first.name
  end

  scenario "should have details" do
    visit project_path(@first)
    record_div = page.find(".project.single_record")
    [:name, :url, :description].each do |attr|
      record_div.should have_content @first.send(attr)
    end
  end

  scenario "should show edit and delete links to anonymous users" do
    visit project_path(@first)
    page.should have_selector(".record_actions .edit")
    page.should have_selector(".record_actions .delete")
  end
end

feature "The project delete button" do
  background do
    setup_projects
  end

  scenario "should delete projects" do
    signed_in_as(:user) do
      visit projects_path
      page.should have_content @first.name

      visit project_path(@first)
      click_link "Delete"

      visit projects_path
      page.should_not have_content @first.name
    end
  end

  scenario "should not allow anonymous users to delete projects" do
    visit projects_path
    page.should have_content @first.name

    visit project_path(@first)
    click_link "Delete"

    current_path.should == new_user_session_path

    visit projects_path
    page.should have_content @first.name
  end
end

feature "The new project form" do
  scenario "should allow users to add a project" do
    # where attributes are defined as the things that are actually stored on the project model, not tags or other bits
    signed_in_as(:user) do
      visit new_project_path
      @from_factory = Factory.build(:project)

      within 'form.project' do
        fill_in 'project_name', :with => @from_factory.name
        fill_in 'project_description', :with => @from_factory.description
        fill_in 'project_url', :with => @from_factory.url
        attach_file('project_logo', Rails.root.join('spec', 'acceptance', 'support', 'test_photo.png'))
        click_button 'project_submit'
      end

      page.should have_selector '.single_record.project'
      page.should have_selector 'img.logo'
      page.should have_content @from_factory.name
      page.should have_content @from_factory.description
      page.should have_content @from_factory.url
    end
  end

  scenario "should not be accessible to anonymous users" do
    visit new_project_path
    current_path.should == new_user_session_path
  end
end

feature "The project edit form" do
  background do
    setup_projects
  end

  scenario "should not be accessible by anonymous users" do
    visit edit_project_path(@first)

    current_path.should == new_user_session_path
    page.should have_content "sign in"
  end

  scenario "should be accessible to users" do
    signed_in_as(:user) do
      visit edit_project_path(@first)

      current_path.should == edit_project_path(@first)
      page.should have_selector('form.project')
    end
  end

  scenario "should allow editing of a project's attributes" do
    # where attributes are defined as the things that are actually stored on the project model, not tags or other bits
    signed_in_as(:user) do
      visit edit_project_path(@first)

      within 'form.project' do
        fill_in 'project_name', :with => @first.name.reverse
        fill_in 'project_description', :with => @first.description.reverse
        fill_in 'project_url', :with => @first.url.reverse
        click_button 'project_submit'
      end

      current_path.should == project_path(@first)
      page.should have_content @first.name.reverse
      page.should have_content @first.description.reverse
      page.should have_content @first.url.reverse
    end
  end

  scenario "should allow editing of tags" do
    signed_in_as(:user) do
      # Add 'newtag'
      visit edit_project_path(@first)
      within 'form.project' do
        fill_in 'project_tag_list', :with => "newtag"
        click_button 'project_submit'
      end
      page.find(".section.tags").should have_content "newtag"

      # Make sure it shows back up in the edit form
      visit edit_project_path(@first)
      page.find("#project_tag_list").value.should == "newtag"
      
      # Change 'newtag' to 'newertag'
      within 'form.project' do
        fill_in 'project_tag_list', :with => "newertag"
        click_button 'project_submit'
      end
      page.find(".section.tags").should_not have_content "newtag"
      page.find(".section.tags").should have_content "newertag"

      # and finally remove the tag altogether
      visit edit_project_path(@first)
      within 'form.project' do
        fill_in 'project_tag_list', :with => ""
        click_button 'project_submit'
      end
      page.should_not have_selector ".section.tags"
    end
  end

  scenario "should allow editing of technologies" do
    signed_in_as(:user) do
      # Add 'newtechnology'
      visit edit_project_path(@first)
      within 'form.project' do
        fill_in 'project_technology_list', :with => "newtechnology"
        click_button 'project_submit'
      end
      page.find(".section.technologies").should have_content "newtechnology"

      # Make sure it shows back up in the edit form
      visit edit_project_path(@first)
      page.find("#project_technology_list").value.should == "newtechnology"
      
      # Change 'newtechnology' to 'newertechnology'
      within 'form.project' do
        fill_in 'project_technology_list', :with => "newertechnology"
        click_button 'project_submit'
      end
      page.find(".section.technologies").should_not have_content "newtechnology"
      page.find(".section.technologies").should have_content "newertechnology"

      # and finally remove the technology altogether
      visit edit_project_path(@first)
      within 'form.project' do
        fill_in 'project_technology_list', :with => ""
        click_button 'project_submit'
      end
      page.should_not have_selector ".section.technologies"
    end
  end

  scenario "should allow a user to upload a logo" do
    signed_in_as(:user) do
      visit project_path(@first)
      page.should_not have_selector('img.project_logo')

      visit edit_project_path(@first)
      within 'form.project' do
        attach_file('project_logo', Rails.root.join('spec', 'acceptance', 'support', 'test_photo.png'))
        click_button 'project_submit'
      end
      
      page.should have_selector('img.logo')
    end
  end

  scenario "should allow a user to import a logo from the web" do
    pending "not yet implemented"

    FakeWeb.register_uri(:get, "http://example.com/photo.png", 
                         :body => File.read(Rails.root.join('spec', 'acceptance', 'support', 'test_photo.png')))

    signed_in_as(:user) do
      visit project_path(@first)
      page.should_not have_selector('img.project_logo')

      visit edit_project_path(@first)
      within 'form.project' do
        fill_in 'project_logo_import_url', :with => "http://example.com/photo.png"
        click_button 'project_submit'
      end
      
      page.should have_selector('img.logo')
    end
  end
end

