module CacheHelper

  # Cache methods	
  def fetch_or_get(path)
    Rails.cache.fetch(path, expires_in: 3.day) do
      get(path)
    end
  end
  
end
