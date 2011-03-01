module APIClient
  class Facebook < APIClient::OAuth2
    def initialize(auth, options={})
      super(auth)
      @client = ::Mogli::Client.new(auth.access_token)
    end

    def search(query, options = {})
      Mogli::User.search(query, @client, :limit => (options[:limit] || DEFAULT_LIMIT)).map{|fb_search_result|
        fb_user = Mogli::User.find(fb_search_result.id, client)
        self.person_from(fb_user)
      }
    end

    def get(id)
      fb_user = Mogli::User.find(id, @client)
      self.person_from(fb_user) if fb_user.present?
    end

    def person_from(fb_user)
      # Facebook's large image URL redirects from https to http, which open-uri forbids.
      photo_url = fb_user.large_image_url.gsub!("https://graph.facebook.com/", "http://graph.facebook.com/")

      Person.new( :name                   => fb_user.name,
                  :bio                    => fb_user.bio,
                  :photo_import_url       => photo_url,
                  :url                    => fb_user.website,
                  :location               => fb_user.location.try(:name) ) \
                  .tap{|person|
                    person.imported_from_provider = 'facebook'
                    person.imported_from_id       = fb_user.id
                  }
    end
  end
end
