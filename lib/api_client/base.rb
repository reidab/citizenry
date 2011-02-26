module APIClient
  class Base
    attr_reader :client

    def initialize(auth, options={})
      @auth = auth
    end
  end
end
