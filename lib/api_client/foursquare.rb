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
        Person.new(:name => [fs_user.firstname, fs_user.lastname].join(' '),
                   :avatar_url => fs_user.photo,
                   :location => fs_user.homecity,
                   :imported_from_provider => 'foursquare',
                   :imported_from_id => fs_user.id)
      }
    end
  end
end

