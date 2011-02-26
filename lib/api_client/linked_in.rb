module APIClient
  class LinkedIn < APIClient::OAuth
    def initialize(auth, options={})
      super(auth)

      @client = ::LinkedIn::Client.new( SETTINGS['auth_credentials']['linked_in']['key'],
                                        SETTINGS['auth_credentials']['linked_in']['secret'] )
      @client.authorize_from_access(@auth.access_token, @auth.access_token_secret)
    end
  end
end
