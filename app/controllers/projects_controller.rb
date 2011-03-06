class ProjectsController < InheritedResources::Base
  respond_to :html, :xml, :json

  before_filter :authenticate_user!, :except => [:index, :show, :tag]

  def tag
    @tag = params[:tag]
    @projects = Project.tagged_with(@tag)

    render :action => :index
  end

  def show
    @project = Project.includes(:people).find(params[:id])
  end

  def join
    @project.people << current_person if current_person
    redirect_to :action => :show
  end

  def leave
    @project.people.delete(current_person) if current_person
    redirect_to :action => :show
  end
end
