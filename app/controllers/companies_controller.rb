class CompaniesController < InheritedResources::Base
  respond_to :html, :xml, :json

  before_filter :authenticate_user!, :except => [:index, :show, :tag]

  def tag
    @tag = params[:tag]
    @companies = Company.tagged_with(@tag)

    render :action => :index
  end

  def show
    @company = Company.includes(:employees).find(params[:id])

    super
  end

  def join
    resource.employees << current_person if current_person
    redirect_to :action => :show
  end

  def leave
    resource.employees.delete(current_person) if current_person
    redirect_to :action => :show
  end
end
