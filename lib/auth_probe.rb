class AuthProbe
  attr_accessor :email

  def self.discover(email)
    STRATEGIES.each do |strategy|
      if result = strategy.discover(email)
        return result
      end
    end

    nil
  end

  def self.discover_all(email)
    results = []
    STRATEGIES.each do |strategy|
      results << result = strategy.discover(email)
    end

    results
  end

  module Strategy
    module WebFinger
      def self.discover(email)
        openid_result = Redfinger.finger(email).open_id.first
        openid_result.nil? ? nil : [:open_id, { :openid_url => openid_result.href }]
      rescue Redfinger::ResourceNotFound
        nil
      end
    end

    module HostOpenID
      def self.discover(email)
        host = email.split("@").last
        discovery = OpenID.discover(host).last.first

        discovery.nil? ? nil : [:open_id, { :openid_url => host }]
      rescue OpenID::DiscoveryFailure
        nil
      end
    end

    module GoogleAppsMX
      def self.discover(email)
        host = email.split("@").last
        resolver = Net::DNS::Resolver.new(:nameservers => "8.8.8.8")
        dns = resolver.search(host, Net::DNS::MX)
        if dns.each_address.any?{|answer| answer.exchange.include?("google")}
          if host.include?('gmail') || host.include?('google')
            [:google, nil]
          else
            [:google_apps, { :domain => host }]
          end
        else
          nil
        end
      end
    end
 
    module YahooMailMX
      def self.discover(email)
        host = email.split("@").last
        resolver = Net::DNS::Resolver.new(:nameservers => "8.8.8.8")
        dns = resolver.search(host, Net::DNS::MX)
        if dns.each_address.any?{|answer| answer.exchange.include?("mail.yahoo.com")}
          [:open_id, { :openid_url => 'http://yahoo.com' }]
        else
          nil
        end
      end
    end

    module Twitter
      def self.discover(email)
        twitter_user_exists = !(HTTParty.get("http://twitter.com/users/email_available", :body => {:email => email}).parsed_response['valid'])
        twitter_user_exists ? [:twitter, nil] : nil
      end
    end

    module Facebook
      def self.discover(email)
        token = "2227470867|2.Qc2Uk25ASvCOpGzCePEXEQ__.3600.1297152000-100001040613184|4qe_KyKiBFc_njg9uD-Rn-OsLIs"
        facebook_query = HTTParty.get("https://graph.facebook.com/search", :query => {:q => email, :type => 'user', :access_token => token}).parsed_response["data"]
        facebook_user_exists = facebook_query && facebook_query.size > 0
        facebook_user_exists ? [:facebook, nil] : nil
      end
    end

    module GitHub
      def self.discover(email)
        HTTParty.get("http://github.com/api/v2/json/user/email/#{CGI::escape email}").parsed_response.has_key?("user") ? [:github, nil] : nil
      end
    end
  end

   STRATEGIES = [Strategy::Twitter,
                Strategy::WebFinger,
                Strategy::HostOpenID,
                Strategy::GoogleAppsMX,
                Strategy::YahooMailMX,
                Strategy::GitHub]
end
