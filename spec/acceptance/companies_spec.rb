require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

def setup_companies
  DatabaseCleaner.clean
  @first  = Factory(:company)
  @second = Factory(:company)
  @third  = Factory(:company)
  @companies = [@first, @second, @third]
end

feature "The company index" do
  background do
    setup_companies
  end

  scenario "should list companies" do
    visit companies_path
    page.should have_css "ul.companies.resource_list li", :count => 3
    @companies.each do |company|
      page.should have_content company.name
    end
  end
end

feature "The company show page" do
  background do
    setup_companies
  end

  scenario "should be able to access a company from the list" do
    visit companies_path
    click_link @first.name
    current_path.should == company_path(@first)
    page.find(".company.single_record").should have_content @first.name
  end

  scenario "should have details" do
    visit company_path(@first)
    record_div = page.find(".company.single_record")
    [:name, :url, :address, :description].each do |attr|
      record_div.should have_content @first.send(attr)
    end
  end

  scenario "should show edit and delete links to anonymous users" do
    visit company_path(@first)
    page.should have_selector(".record_actions .edit")
    page.should have_selector(".record_actions .delete")
  end
end

feature "The company delete button" do
  background do
    setup_companies
  end

  scenario "should delete companies" do
    signed_in_as(:user) do
      visit companies_path
      page.should have_content @first.name

      visit company_path(@first)
      click_link "Delete"

      visit companies_path
      page.should_not have_content @first.name
    end
  end

  scenario "should not allow anonymous users to delete companies" do
    visit companies_path
    page.should have_content @first.name

    visit company_path(@first)
    click_link "Delete"

    current_path.should == new_user_session_path

    visit companies_path
    page.should have_content @first.name
  end
end

feature "The new company form" do
  scenario "should allow users to add a company" do
    # where attributes are defined as the things that are actually stored on the company model, not tags or other bits
    signed_in_as(:user) do
      visit new_company_path
      @from_factory = Factory.build(:company)

      within 'form.company' do
        fill_in 'company_name', :with => @from_factory.name
        fill_in 'company_address', :with => @from_factory.address
        fill_in 'company_description', :with => @from_factory.description
        fill_in 'company_url', :with => @from_factory.url
        attach_file('company_logo', Rails.root.join('spec', 'acceptance', 'support', 'test_photo.png'))
        click_button 'company_submit'
      end

      page.should have_selector '.single_record.company'
      page.should have_selector 'img.logo'
      page.should have_content @from_factory.name
      page.should have_content @from_factory.address
      page.should have_content @from_factory.description
      page.should have_content @from_factory.url
    end
  end

  scenario "should not be accessible to anonymous users" do
    visit new_company_path
    current_path.should == new_user_session_path
  end
end

feature "The company edit form" do
  background do
    setup_companies
  end

  scenario "should not be accessible by anonymous users" do
    visit edit_company_path(@first)

    current_path.should == new_user_session_path
    page.should have_content "sign in"
  end

  scenario "should be accessible to users" do
    signed_in_as(:user) do
      visit edit_company_path(@first)

      current_path.should == edit_company_path(@first)
      page.should have_selector('form.company')
    end
  end

  scenario "should allow editing of a company's attributes" do
    # where attributes are defined as the things that are actually stored on the company model, not tags or other bits
    signed_in_as(:user) do
      visit edit_company_path(@first)

      within 'form.company' do
        fill_in 'company_name', :with => @first.name.reverse
        fill_in 'company_address', :with => @first.address.reverse
        fill_in 'company_description', :with => @first.description.reverse
        fill_in 'company_url', :with => @first.url.reverse
        click_button 'company_submit'
      end

      current_path.should == company_path(@first)
      page.should have_content @first.name.reverse
      page.should have_content @first.address.reverse
      page.should have_content @first.description.reverse
      page.should have_content @first.url.reverse
    end
  end

  scenario "should allow editing of tags" do
    signed_in_as(:user) do
      # Add 'newtag'
      visit edit_company_path(@first)
      within 'form.company' do
        fill_in 'company_tag_list', :with => "newtag"
        click_button 'company_submit'
      end
      page.find(".section.tags").should have_content "newtag"

      # Make sure it shows back up in the edit form
      visit edit_company_path(@first)
      page.find("#company_tag_list").value.should == "newtag"
      
      # Change 'newtag' to 'newertag'
      within 'form.company' do
        fill_in 'company_tag_list', :with => "newertag"
        click_button 'company_submit'
      end
      page.find(".section.tags").should_not have_content "newtag"
      page.find(".section.tags").should have_content "newertag"

      # and finally remove the tag altogether
      visit edit_company_path(@first)
      within 'form.company' do
        fill_in 'company_tag_list', :with => ""
        click_button 'company_submit'
      end
      page.should_not have_selector ".section.tags"
    end
  end

  scenario "should allow editing of technologies" do
    signed_in_as(:user) do
      # Add 'newtechnology'
      visit edit_company_path(@first)
      within 'form.company' do
        fill_in 'company_technology_list', :with => "newtechnology"
        click_button 'company_submit'
      end
      page.find(".section.technologies").should have_content "newtechnology"

      # Make sure it shows back up in the edit form
      visit edit_company_path(@first)
      page.find("#company_technology_list").value.should == "newtechnology"
      
      # Change 'newtechnology' to 'newertechnology'
      within 'form.company' do
        fill_in 'company_technology_list', :with => "newertechnology"
        click_button 'company_submit'
      end
      page.find(".section.technologies").should_not have_content "newtechnology"
      page.find(".section.technologies").should have_content "newertechnology"

      # and finally remove the technology altogether
      visit edit_company_path(@first)
      within 'form.company' do
        fill_in 'company_technology_list', :with => ""
        click_button 'company_submit'
      end
      page.should_not have_selector ".section.technologies"
    end
  end

  scenario "should allow a user to upload a logo" do
    signed_in_as(:user) do
      visit company_path(@first)
      page.should_not have_selector('img.company_logo')

      visit edit_company_path(@first)
      within 'form.company' do
        attach_file('company_logo', Rails.root.join('spec', 'acceptance', 'support', 'test_photo.png'))
        click_button 'company_submit'
      end
      
      page.should have_selector('img.logo')
    end
  end

  scenario "should allow a user to import a logo from the web" do
    pending "not yet implemented"

    FakeWeb.register_uri(:get, "http://example.com/photo.png", 
                         :body => File.read(Rails.root.join('spec', 'acceptance', 'support', 'test_photo.png')))

    signed_in_as(:user) do
      visit company_path(@first)
      page.should_not have_selector('img.company_logo')

      visit edit_company_path(@first)
      within 'form.company' do
        fill_in 'company_logo_import_url', :with => "http://example.com/photo.png"
        click_button 'company_submit'
      end
      
      page.should have_selector('img.logo')
    end
  end
end

