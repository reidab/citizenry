class UsersController < InheritedResources::Base
  respond_to :html, :xml, :json

  before_filter :authenticate_user!, :only => [:welcome, :home]
  before_filter :require_admin!, :except => [:show, :home, :welcome]

  def show
    if resource.person
      redirect_to person_path(resource.person)
    else
      if current_user && current_user.admin?
        redirect_to users_path(:anchor => "user_#{resource.id}")
      else
        raise ActiveRecord::RecordNotFound
      end
    end
  end

  def home
    redirect_to :action => :welcome and return unless current_user.person.try(:reviewed)
  end

  def welcome
    redirect_to :action => :home and return if current_user.person.try(:reviewed)

    @name = current_user.name || params[:name]
    @person = current_user.person || current_user.authentications.first.to_person || Person.new

    if @person.new_record?
      if @name.present?
        @possible_duplicates = Person.unclaimed.where(:name => @name).all

        name_parts = @name.split(' ')
        name_part_query = (["name LIKE ?"] * name_parts.size).join(' or ')
        @possible_duplicates += Person.unclaimed.where(name_part_query, *name_parts.map{|p| "%#{p}%"}).take(10)

        @possible_duplicates.uniq!

        @person.send(:set_slug)
      end
    end
  end

  def index
    @users = User.includes(:authentications, :person).all
  end

  # def destroy

  def adminify
    @user.admin = !(@user.admin)
    @user.save

    redirect_to users_path
  end
end

