class Users::SessionsController < ApplicationController
  def new
    @signin_data = SignInData.new
  end
end
