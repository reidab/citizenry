class GroupsController < InheritedResources::Base
  respond_to :html, :xml, :json
  custom_actions  :collection => :tag,
                  :resource => [:join, :leave]

  before_filter :authenticate_user!, :except => [:index, :show, :tag]

  def tag
    @tag = params[:tag]
    @groups = Group.tagged_with(@tag)

    tag! do |format|
      format.html { render :action => :index }
    end
  end

  def join
    resource.members << current_person if current_person
    join!{ {:action => :show} }
  end

  def leave
    resource.members.delete(current_person) if current_person
    leave!{ {:action => :show} }
  end
end
