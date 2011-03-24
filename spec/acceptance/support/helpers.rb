module HelperMethods
  def sign_in(user_or_user_id_or_factory)
    @user = case user_or_user_id_or_factory
              when Numeric
                User.find(user_or_user_id_or_factory)
              when Symbol
                Factory(user_or_user_id_or_factory)
              when User
                user_or_user_id_or_factory
              else
                raise ArgumentError, "That wasn't a user, a user ID, or a user factory!"
            end

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:default] = {
      'provider' => 'open_id',
      'uid' => @user.authentications.first.uid,
      'user_info' => {}
    }

    visit "/sign_in"

    within '#new_sign_in_data' do
      fill_in 'sign_in_data_email', :with => @user.email
      select 'OpenID', :from => 'sign_in_data_provider'
      click_button 'sign_in_data_submit'
    end
  end

  def sign_out
    visit "/sign_out"
  end

  def signed_in_as(user_or_user_id_or_factory)
    sign_in(user_or_user_id_or_factory)
    begin
      yield if block_given?
    ensure
      sign_out
    end
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
