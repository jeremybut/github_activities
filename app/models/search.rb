class Search
  extend CacheHelper
  include Her::Model

  class << self
    # Search users
    def users(query)
      save query
      fetch_or_get("search/users?q=#{query}")
    end

    # Get saved searches
    def saved_searches
      JSON.parse(redis.get('saved_searches') || '{}')
    end

    private

    # Save search into redis
    def save(query)
      if query != ""
        ss = saved_searches
        ss[query] = Time.now
        redis.set('saved_searches', ss.to_json)
      end
    end

    def redis
      @redis ||= Redis::Store.new
    end
  end
end
