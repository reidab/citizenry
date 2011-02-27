module APIClient
  class LinkedIn < APIClient::OAuth
    def initialize(auth, options={})
      super(auth)

      @client = ::LinkedIn::Client.new( SETTINGS['auth_credentials']['linked_in']['key'],
                                        SETTINGS['auth_credentials']['linked_in']['secret'] )
      @client.authorize_from_access(@auth.access_token, @auth.access_token_secret)
    end

    def search(query, options = {})
      @client.search(:keywords => query, :count => (options[:limit] || DEFAULT_LIMIT)).profiles.map{|li_user|
        Person.new(:name => [li_user.first_name,
                             li_user.last_name].reject{|n| n.blank? }.join(' '),
                   :bio => li_user.headline,
                   :avatar_url => li_user.picture_url,
                   :url => li_user.public_profile_url,
                   :location => li_user.location.try(:name),
                   :imported_from_provider => 'linked_in',
                   :imported_from_id => li_user.id)
      }.reject{|p| p.name == "Private"}
    end
  end
end
