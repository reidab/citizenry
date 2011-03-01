module APIClient
  class Foursquare < APIClient::OAuth
    def initialize(auth, options={})
      super(auth)
      fs_auth = ::Foursquare::OAuth.new( SETTINGS['auth_credentials']['foursquare']['key'],
                                         SETTINGS['auth_credentials']['foursquare']['secret'] )
      fs_auth.authorize_from_access(@auth.access_token, @auth.access_token_secret)

      @client = ::Foursquare::Base.new(fs_auth)
    end

    def search(query, options = {})
      @client.findfriends_byname(:q => query, :l => (options[:limit] || DEFAULT_LIMIT)).map{|fs_user|
        self.person_from(fs_user)
      }
    rescue ::Foursquare::Unauthorized => e
      raise APIAuthenticationError, e.inspect
    end

    def get(id)
      fs_user = @client.user(:uid => id)
      self.person_from(fs_user) if fs_user.present?
    rescue ::Foursquare::Unauthorized => e
      raise APIAuthenticationError, e.inspect
    end

    def person_from(fs_user)
      fs_user = Hashie::Mash.new(fs_user) if fs_user.class == Hash

      Person.new( :name                   => [fs_user.firstname, fs_user.lastname].join(' '),
                  :photo_import_url       => fs_user.photo,
                  :location               => fs_user.homecity ) \
                  .tap{|person|
                    person.imported_from_provider = 'foursquare'
                    person.imported_from_id       = fs_user.id
                  }
    end
  end
end

