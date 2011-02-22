class AuthProbe
  attr_accessor :email
  def self.discover(email)
    results = []
    [ Strategy::WebFinger, Strategy::HostOpenID, Strategy::GoogleAppsMX, Strategy::Twitter, Strategy::Facebook, Strategy::GitHub, Strategy::YahooMailMX ].each do |strategy|
      puts "Trying #{strategy}…"
      results << result = strategy.discover(email)
      puts "=> #{result.inspect}"
    end

    puts "\n\n\n"
    results.compact.each do |res|
      puts res.join(": ")
    end
  end

  module Strategy
    module WebFinger
      def self.discover(email)
        openid_result = Redfinger.finger(email).open_id.first
        openid_result.nil? ? nil : [:open_id, openid_result.href]
      rescue Redfinger::ResourceNotFound
        nil
      end
    end

    module HostOpenID
      def self.discover(email)
        host = email.split("@").last
        discovery = OpenID.discover(host).last.first

        discovery.nil? ? nil : [:open_id, host]
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
          [:google_apps, host]
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
          [:open_id, 'http://yahoo.com']
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

    module GitHub
      def self.discover(email)
        HTTParty.get("http://github.com/api/v2/json/user/email/#{CGI::escape email}").parsed_response.has_key?("user") ? [:github, nil] : nil
      end
    end
  end
end
