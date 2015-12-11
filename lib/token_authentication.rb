class TokenAuthentication < Faraday::Middleware
  def call(env)
  	# credentials visible for the test by symbioz
  	# don't forget to replace by var env
    # env[:url].query = env[:url].query.try(:+, "&client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}&access_token=#{ENV['GITHUB_ACCESS_TOKEN']}")
    @app.call(env)
  end
end
