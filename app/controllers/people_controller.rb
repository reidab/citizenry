class PeopleController < InheritedResources::Base
  respond_to :html, :xml, :json
  custom_actions  :collection => :tag,
                  :resource => [:claim, :photo]

  include Localness
  before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :require_owner_or_admin!, :only => [:edit, :update, :destroy]
  before_filter :pick_photo_input, :only => [:update, :create]
  before_filter :set_user_id_if_admin, :only => [:update, :create]

  def index
    @view = :grid if params[:grid]
    index!
  end

  def tag
    @tag = params[:tag]

    tag! do |format|
      format.html { render :action => :index }
    end
  end

  def show
    @person = Person.includes(:companies, :groups, :projects).find(params[:id])
    show!
  end

  def new
    if params[:q].present? && params[:authentications].present?
      query = params[:q]
      authentications = params[:authentications].keys

      @found_people = []
      current_user.authentications.find(authentications).each do |auth|
        if auth.api_client
          begin
            @found_people += auth.api_client.search(query)
          rescue APIAuthenticationError => e
            notify_hoptoad(ex)
          end

          if auth.provider == 'twitter'
            @rate_limit_status = auth.api_client.client.rate_limit_status
          end
        end
      end

      @found_people.sort! {|a,b| localness(b) <=> localness(a)}
      @found_people = Person.all(:conditions => ['name LIKE ?', "%#{query}%"]) + @found_people

    end

    new!
  end

  def create
    if params[:form_context] == 'add_self'
      @person = Person.new(params[:person])
      @person.user = current_user
      @person.imported_from_provider = current_user.authentications.first.provider
      @person.imported_from_id = current_user.authentications.first.uid
    end

    create!
  end

  def claim
    if resource.user.present?
      flash[:error] = "This person has already been claimed."
      redirect_to(:action => 'show') and return
    end
  end

  protected

  def collection
    @people ||= filter_sort_and_paginate(end_of_association_chain, true)
  end

  def require_owner_or_admin!
    authenticate_user! and return unless current_user

    unless current_user.admin? || current_user == resource.user
      flash[:warning] = "You aren't allowed to edit this person."
      redirect_to person_path(@person)
    end
  end

  def pick_photo_input
    params.delete(:photo_import_label) if params[:photo].present?
  end

  def set_user_id_if_admin
    if current_user.admin? && params[:person] && params[:person][:user_id].present?
      resource.user_id = params[:person][:user_id]
    end
  end
end
