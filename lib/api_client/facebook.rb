module APIClient
  class Facebook < APIClient::OAuth2
    def initialize(auth, options={})
      super(auth)
      @client = ::Mogli::Client.new(auth.access_token)
    end
  end
end
