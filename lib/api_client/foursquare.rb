module APIClient
  class Foursquare < APIClient::OAuth2
    def initialize(auth, options={})
      super(auth)

      # If we have a secret from OAuth1, we can use it here.
      access_token = @auth.access_token_secret || @auth.access_token
      @client = Foursquare2::Client.new(:oauth_token => access_token)
    end

    def search(query, options = {})
      @client.search_users(:name => query).results.map{|fs_user|
        self.person_from(fs_user)
      }
    rescue ::Foursquare::Unauthorized => e
      raise APIAuthenticationError, e.inspect
    end

    def get(id)
      fs_user = @client.user(id)
      self.person_from(fs_user) if fs_user.present?
    rescue ::Foursquare::Unauthorized => e
      raise APIAuthenticationError, e.inspect
    end

    def person_from(fs_user)
      fs_user = Hashie::Mash.new(fs_user) if fs_user.class == Hash

      Person.new( :name                   => [fs_user.firstName, fs_user.lastName].join(' '),
                  :photo_import_url       => fs_user.photo,
                  :location               => fs_user.homeCity ) \
                  .tap{|person|
                    person.imported_from_provider = 'foursquare'
                    person.imported_from_id       = fs_user.id
                  }
    end
  end
end

