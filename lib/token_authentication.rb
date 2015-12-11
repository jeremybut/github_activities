class TokenAuthentication < Faraday::Middleware
  def call(env)
  	# credentials visible for the test by symbioz
  	# don't forget to replace by var env
    env[:url].query = env[:url].query.try(:+, '&client_id=74ae307dcfd891286d1e&client_secret=cc3aecf10c129d9cddab4a752b4c5b8be2bedd64&access_token=95a93164cfef00e9b89431681ff6bb5c7bff4f69')
    @app.call(env)
  end
end
