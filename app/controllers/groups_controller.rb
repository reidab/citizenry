class GroupsController < InheritedResources::Base
  respond_to :html, :xml, :json

  before_filter :authenticate_user!, :except => [:index, :show, :tag]

  def tag
    @tag = params[:tag]
    @groups = Group.tagged_with(@tag)

    render :action => :index
  end

  def join
    @group.members << current_person if current_person
    redirect_to :action => :show
  end

  def leave
    @group.members.delete(current_person) if current_person
    redirect_to :action => :show
  end
end
