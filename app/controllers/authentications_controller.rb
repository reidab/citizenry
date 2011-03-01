class AuthenticationsController < ApplicationController
  class SessionRequired < Exception; end

  def index
    @authentications = current_user.authentications.all
  end

  def route_login
    @signin_data = SignInData.new(params[:sign_in_data])
    render(:action => :login) and return unless @signin_data.valid?

    session[:login_email] = @signin_data.email

    if @signin_data.provider == 'auto'
      redirect_to :action => :auto, :email => @signin_data.email
    else
      redirect_to "/auth/#{@signin_data.provider}"
    end
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

  def create
    omniauth = request.env["omniauth.auth"]

    if auth = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      # Existing user, existing authentication, login!
      auth.update_from_omniauth(omniauth)
      auth.save
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(auth.user)
    elsif current_user
      # Logged in user => give them a new authentication
      Authentication.create_from_omniauth!(omniauth, :user => current_user)
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      # Entirely new user

      if session[:login_email].blank?
        flash[:error] = "Ack! It looks like you might have cookies disabled. Please re-enable cookies and try again."
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
    @authentication = Authentication.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
