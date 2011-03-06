require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :json, :xml

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

  def page_title(value=nil)
    @page_title = value unless value.nil?

    if @page_title.nil?
      @page_title ||=
        case action_name.to_sym
        when :index
          controller_name.titleize
        when :new, :create
          "New " + controller_name.singularize.humanize.downcase
        when :edit, :update
          "Edit " + controller_name.singularize.humanize.downcase
        when :destroy
          "Destroy " + controller_name.singularize.humanize.downcase
        else
          begin
            get_resource_ivar.name
          rescue Exception => e
            controller_name.singularize.humanize.titleize
          end
        end
    else
      @page_title
    end
  end
  helper_method :page_title
end
