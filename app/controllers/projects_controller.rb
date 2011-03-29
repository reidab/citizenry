class ProjectsController < InheritedResources::Base
  respond_to :html, :xml, :json
  custom_actions  :collection => :tag,
                  :resource => [:join, :leave]

  before_filter :authenticate_user!, :except => [:index, :show, :tag]

  def tag
    @tag = params[:tag]
    @projects = Project.tagged_with(@tag)

    tag! do |format|
      format.html { render :action => :index }
    end
  end

  def show
    @project = Project.includes(:people).find(params[:id])
    show!
  end

  def join
    resource.people << current_person if current_person
    join!{ {:action => :show} }
  end

  def leave
    resource.people.delete(current_person) if current_person
    leave!{ {:action => :show} }
  end

  protected

  def collection
    @projects ||= filter_sort_and_paginate(end_of_association_chain)
  end
end
