class ApplicationController < ActionController::Base
  protect_from_forgery

  def authentication_succeeded(message=nil)
    flash[:notice] = message
    # Is this a new user?
    if (current_user.created_at > (1.minute.ago))
      if person = Person.find_by_twitter(current_user.login)
        person.update_attribute(:user_id, current_user.id)
        flash[:notice] = "Welcome! This is the first time you've logged in, "
          + "but it looks like someone has already added you to the directory. "
          + "Take a look at your profile here and edit as you see fit."
        redirect_to person_path(person)
      else
        redirect_to welcome_users_path
      end
    else
      redirect_back_or_default(root_path)
    end
  end

  def current_person
    current_user && current_user.person
  end
  helper_method :current_person

  def require_admin!
    authenticate_user! and return unless current_user
    unless current_user.admin?
      flash[:error] = "Access denied."
      redirect_to root_path and return
    end
  end
end
