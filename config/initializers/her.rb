require_relative "../../lib/token_authentication.rb"

Her::API.setup url: "https://api.github.com" do |c|
  # Request
  c.use Faraday::Request::UrlEncoded
  c.use TokenAuthentication
  # Response
  c.use Her::Middleware::DefaultParseJSON

  # Error
  c.use Faraday::Response::RaiseError

  # Adapter
  c.use Faraday::Adapter::NetHttp
end
