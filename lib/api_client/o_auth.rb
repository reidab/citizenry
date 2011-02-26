module APIClient
  class OAuth < APIClient::Base
    def initialize(auth, options={})
      super
      @client = access_token_object
    end

    def consumer
      OAUTH_CONSUMERS[@auth.provider]
    end

    def access_token_object
      ::OAuth::AccessToken.new(consumer, @auth.access_token, @auth.access_token_secret)
    end
  end
end
