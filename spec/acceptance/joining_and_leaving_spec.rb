require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "A user with a linked person should be join and leave things:" do
  [:group, :project, :company].each do |thing|
    scenario "They should be able to join and leave #{thing.to_s.pluralize}" do
      @thing = Factory(thing)
      signed_in_as(:user_with_person) do
        visit url_for(@thing)
        page.should have_selector "a.join"

        click_link("Join this #{thing}")
        page.find('.section.members').should have_content @user.person.name
        page.should have_selector "a.leave"

        click_link("Leave this #{thing}")
        page.find('.section.members').should_not have_content @user.person.name
        page.should have_selector "a.join"
      end
    end
  end
end
