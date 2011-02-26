module APIClient
  class Foursquare < APIClient::OAuth
    def initialize(auth, options={})
      super(auth)
      fs_auth = ::Foursquare::OAuth.new( SETTINGS['auth_credentials']['foursquare']['key'],
                                         SETTINGS['auth_credentials']['foursquare']['secret'] )
      fs_auth.authorize_from_access(@auth.access_token, @auth.access_token_secret)

      @client = ::Foursquare::Base.new(fs_auth)
    end
  end
end

