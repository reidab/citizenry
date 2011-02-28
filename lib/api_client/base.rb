module APIClient
  class Base
    DEFAULT_LIMIT = 5
    attr_reader :client

    def initialize(auth, options={})
      @auth = auth
    end

    def search(query, options = {})
      []
    end

    def get(id)
      nil
    end
  end
end
