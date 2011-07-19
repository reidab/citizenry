module PeopleHelper
  def people_list_title(list, tag)
    singular_title = "#{tag} person"
    if mentoring_enabled?
      singular_title = "interested mentor" if params[:mentors]
      singular_title = "interested mentee" if params[:mentees]
    end

    semantic_pluralize(
      list.respond_to?(:total_entries) ? list.total_entries : list.size,
      singular_title.strip.titleize
    )
  end
end
