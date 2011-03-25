class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound do |exception|
    respond_to do |format|
      format.html {
        flash.now[:error] = 'Record not found'
        render :template => 'site/404', :status => 404
      }
      format.xml  { head 404 }
      format.json { head 404 }
    end
  end

  protected

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
