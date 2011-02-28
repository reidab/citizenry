class UsersController < ApplicationController
  before_filter :load_user, :only => [:show]
  before_filter :authenticate_user!, :only => [:welcome]

  def show
    if @user.person
      redirect_to person_path(@user.person)
    end
  end

  def welcome
    @name = current_user.name || params[:name]
    @person = current_user.person || current_user.authentications.first.to_person || Person.new

    if @person.new_record?
      if @name.present?
        @possible_duplicates = Person.unclaimed.where(:name => @name).all

        name_parts = @name.split(' ')
        name_part_query = (["name LIKE ?"] * name_parts.size).join(' or ')
        @possible_duplicates += Person.unclaimed.where(name_part_query, *name_parts.map{|p| "%#{p}%"}).take(10)

        @possible_duplicates.uniq!
      end
    end
  end

  private
  def load_user
    @user = User.find(params[:id])
  end
end

