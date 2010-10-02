class UsersController < ApplicationController
  before_filter :load_user

  def show
    if @user.person
      redirect_to person_path(@user.person)
    else
      @person = Person.from_user(@user)
    end
  end

  private
  def load_user
    @user = User.find(params[:id])
  end
end

