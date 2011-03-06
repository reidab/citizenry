class ResourcesController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @resources = Resource.all.group_by(&:category)
  end

  def show
    redirect_to resources_path(:anchor => params[:id])
  end
end
