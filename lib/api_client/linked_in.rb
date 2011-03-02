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
        self.person_from(li_user)
      }.reject{|p| p.name == "Private"}
    rescue ::LinkedIn::Unauthorized => e
      raise APIAuthenticationError, e.inspect
    end

    def get(id)
      li_user = @client.profile(:id => id, :fields => [:id, :first_name, :last_name, :headline, :picture_url, :public_profile_url, :location])
      self.person_from(li_user) if li_user.present?
    rescue ::LinkedIn::Unauthorized => e
      raise APIAuthenticationError, e.inspect
    end

    def picture_url_for(li_user)
      if li_user.picture_url.present?
        li_user.picture_url
      else
        @client.profile(:id => li_user.id, :fields => ['picture_url']).picture_url
      end
    end

    def person_from(li_user)
      Person.new( :name                   => [li_user.first_name, li_user.last_name].reject{|n| n.blank? }.join(' '),
                  :bio                    => li_user.headline,
                  :photo_import_url       => picture_url_for(li_user),
                  :url                    => li_user.public_profile_url,
                  :location               => li_user.location.try(:name) ) \
                  .tap{|person|
                    person.imported_from_provider = 'linked_in'
                    person.imported_from_id       = li_user.id
                  }
    end
  end
end
