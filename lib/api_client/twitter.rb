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
        self.person_from(twitter_user)
      }
    rescue ::Twitter::NotFound
      []
    rescue ::Twitter::Unauthorized => e
      raise APIAuthenticationError, e.inspect
    end

    def get(id)
      twitter_user = @client.user(:user_id => id)
      self.person_from(twitter_user) if twitter_user.present?
    rescue ::Twitter::NotFound
      nil
    rescue ::Twitter::Unauthorized => e
      raise APIAuthenticationError, e.inspect
    end

    def person_from(twitter_user)
      full_size_avatar = twitter_user.profile_image_url.gsub(/_normal(\.\w{3})$/, '\1')
      Person.new( :name                   => twitter_user.name,
                  :bio                    => twitter_user.description,
                  :photo_import_url       => full_size_avatar,
                  :url                    => twitter_user.url,
                  :location               => twitter_user.location ) \
                  .tap{|person|
                    person.imported_from_provider    = 'twitter'
                    person.imported_from_id          = twitter_user.id
                    person.imported_from_screen_name = twitter_user.screen_name
                  }
    end
  end
end
