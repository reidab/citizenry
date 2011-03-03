class Users::SessionsController < ApplicationController
  def new
    @signin_data = SignInData.new
  end

  def create
    @signin_data = SignInData.new(params[:sign_in_data])
    render(:action => :new) and return unless @signin_data.valid?

    session[:login_email] = @signin_data.email

    if @signin_data.provider == 'auto'
      redirect_to :controller => '/authentications', :action => :auto, :email => @signin_data.email
    else
      redirect_to "/auth/#{@signin_data.provider}"
    end
  end
end
