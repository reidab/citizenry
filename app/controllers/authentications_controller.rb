class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications.all
  end

  def login
    email = session[:login_email] = params[:email]
    provider = params[:provider].to_sym

    if provider == :auto
      redirect_to :action => :auto, :email => params[:email]
    else
      redirect_to "/auth/#{provider}"
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

    if authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      Authentication.create_from_omniauth!(omniauth, :user => current_user)
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      auth = Authentication.create_from_omniauth!(omniauth, :new_user => {:email => session[:login_email]})
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, auth.user)
    end
    session[:login_email] = nil
  end

  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
