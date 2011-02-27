module APIClient
  class Facebook < APIClient::OAuth2
    def initialize(auth, options={})
      super(auth)
      @client = ::Mogli::Client.new(auth.access_token)
    end

    def search(query, options = {})
      Mogli::User.search(query, @client, :limit => (options[:limit] || DEFAULT_LIMIT)).map{|fb_search_result|
        fb_user = Mogli::User.find(fb_search_result.id, client)

        Person.new(:name => fb_user.name,
                   :bio => fb_user.bio,
                   :avatar_url => fb_user.image_url,
                   :url => fb_user.website,
                   :location => fb_user.location.try(:name),
                   :imported_from_provider => 'facebook',
                   :imported_from_id => fb_user.id)
      }
    end
  end
end
