module APIClient
  class OAuth2 < APIClient::Base
    def initialize(auth, options={})
      super
      @client = access_token_object
    end

    def consumer
      OAUTH_CONSUMERS[@auth.provider]
    end

    def access_token_object
      ::OAuth2::AccessToken.new(consumer, @auth.access_token)
    end
  end
end
