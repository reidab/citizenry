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

    def search(query, options = {})
      @client.user_search(query, :per_page => (options[:limit] || DEFAULT_LIMIT)).map{|twitter_user|
        Person.new(:name => twitter_user.name,
                   :bio => twitter_user.description,
                   :avatar_url => twitter_user.profile_image_url,
                   :url => twitter_user.url,
                   :location => twitter_user.location,
                   :imported_from_provider => 'twitter',
                   :imported_from_id => twitter_user.id)
      }
    end
  end
end
