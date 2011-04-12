class AuthenticationsController < ApplicationController
  class SessionRequired < Exception; end

  before_filter :authenticate_user!, :only => [:destroy]
  skip_before_filter :verify_authenticity_token, :only => :create

  def index
    @authentications = current_user.authentications.all
  end

  def auto
    @email = params[:email]
    session[:login_email] = @email

    if user = User.find_by_email(@email)
      auth = user.default_authentication
      provider = auth.provider
      options = { :openid_url => auth.uid } if auth.provider == :open_id
    else
      provider, options = AuthProbe.discover(@email)
    end

    if provider
      if options
        querystring =  '?' + options.keys.inject('') do |query_string, key|
          query_string << '&' unless key == options.keys.first
          query_string << "#{URI.encode(key.to_s)}=#{URI.encode(options[key])}"
        end
      end

      redirect_to "/auth/#{provider}#{querystring}"
    else
      render
    end
  end

  def auth_failure
    # just render the failure view
  end

  def create
    omniauth = request.env["omniauth.auth"]

    if auth = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      # Existing user, existing authentication, login!
      auth.update_from_omniauth(omniauth)
      auth.save
      sign_in(auth.user)
      redirect_to stored_location_for(:user) || (auth.user.person.try(:reviewed) ? home_users_path : welcome_users_path)
    elsif current_user
      # Logged in user => give them a new authentication
      Authentication.create_from_omniauth!(omniauth, :user => current_user)
      flash[:success] = "Your #{OmniAuth::Utils.camelize(omniauth['provider'])} account has been added."
      redirect_to home_users_path
    else
      # Entirely new user

      if session[:login_email].blank?
        flash[:error] = "It looks like you might have cookies disabled. Please re-enable cookies and try again."
      elsif User.find_by_email(session[:login_email])
        flash[:error] = "A user already exists for #{session[:login_email]}, but you're using a different login method than we've seen for them. Please try again with with the 'choose automatically' option selected."
      else
        auth = Authentication.create_from_omniauth!(omniauth, :new_user => {:email => session[:login_email]})
        flash[:notice] = "Signed in successfully."
      end

      session[:login_email] = nil

      if auth.present?
        sign_in(auth.user)
        redirect_to stored_location_for(:user) || welcome_users_path
      else
        redirect_to sign_in_path
      end
    end
  end

  def destroy
    if current_user.admin?
      @authentication = Authentication.find(params[:id])
    else
      @authentication = current_user.authentications.find(params[:id])
    end
    @authentication.destroy
    flash[:success] = "Your #{OmniAuth::Utils.camelize(@authentication.provider)} account has been removed."
    redirect_to home_users_path
  end
end
