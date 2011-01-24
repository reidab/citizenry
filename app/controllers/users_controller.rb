class UsersController < ApplicationController
  before_filter :load_user, :only => [:show]
  before_filter :authenticate_user!, :only => [:welcome]

  def show
    if @user.person
      redirect_to person_path(@user.person)
    else
      @person = Person.from_user(@user)
    end
  end

  def welcome
  end

  private
  def load_user
    @user = User.find(params[:id])
  end
end

