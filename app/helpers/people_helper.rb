module PeopleHelper
  def people_list_title(list, tag)
    title_key = 'title'
    if mentoring_enabled?
      title_key = 'mentor_title' if params[:mentors]
      title_key = 'mentee_title' if params[:mentees]
    end

    semantic_pluralize(
      list.respond_to?(:total_entries) ? list.total_entries : list.size,
      t("people.index.#{title_key}.one", :tag => tag).strip.titleize,
      t("people.index.#{title_key}.other", :tag => tag).strip
    )
  end

  def display_record_controls?(person)
    current_user && (current_user.admin? || current_user.person == person)
  end

  def display_login_as_control?(person)
    person.user && (current_user != person.user) && allow_login_as_specific_user?
  end
end
