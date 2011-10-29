module PeopleHelper
  def display_record_controls?(person)
    current_user && (current_user.admin? || current_user.person == person)
  end

  def display_login_as_control?(person)
    person.user && (current_user != person.user) && allow_login_as_specific_user?
  end
end
