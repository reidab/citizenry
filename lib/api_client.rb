# Provides a common interface for interacting with various oauthed services
module APIClient
  class APIAuthenticationError < StandardError; end

  def self.for(auth, options={})
    return ("APIClient::" + OmniAuth::Utils.camelize(auth.provider)).constantize.new(auth, options)
  rescue NameError
    consumer = OAUTH_CONSUMERS[auth.provider]

    if consumer.is_a?(::OAuth::Consumer)
      return APIClient::OAuth.new(auth)
    elsif consumer.is_a?(::OAuth2::Client)
      return APIClient::OAuth2.new(auth)
    else
      return nil
    end
  end
end
