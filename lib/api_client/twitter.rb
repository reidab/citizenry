module APIClient
  class Twitter < APIClient::OAuth
    def initialize(auth, options={})
      super(auth)
      @client = ::Twitter.client(
                  :consumer_key => SETTINGS['auth_credentials']['twitter']['key'],
                  :consumer_secret => SETTINGS['auth_credentials']['twitter']['secret'],
                  :oauth_token => @auth.access_token,
                  :oauth_token_secret => @auth.access_token_secret)
    end
  end
end
