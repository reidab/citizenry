class ApplicationController < ActionController::Base
  protect_from_forgery

  def authentication_succeeded(message=nil)
    redirect_to user_path(current_user)
  end
end
