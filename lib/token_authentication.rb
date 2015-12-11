class TokenAuthentication < Faraday::Middleware
  def call(env)
  	# credentials visible for the test by symbioz
  	# don't forget to replace by var env
    env[:url].query = env[:url].query.try(:+, '&client_id=df30a9b91a912beb28f0&client_secret=f5095953cb957bdd5a1ded64c2978f0765f6cef3&access_token=bb45ec13e32b1b3f6d95a029422cf5a0535f4c5e')
    @app.call(env)
  end
end
