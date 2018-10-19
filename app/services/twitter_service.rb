require "cgi"
require "base64"

class TwitterService
  def initialize(config)
    # see https://developer.twitter.com/en/docs/basics/authentication/overview/application-only.html
    key_and_secret = "#{CGI::escape(config[:key])}:#{CGI::escape(config[:secret])}"

    # auth_response will be {"token_type":"bearer","access_token":"TOKEN"}
    auth_response = HTTParty.post('https://api.twitter.com/oauth2/token', {
      :headers => {
        'Authorization' => "Basic #{Base64.strict_encode64(key_and_secret)}",
        'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8'
      },
      :body => {
        :grant_type => 'client_credentials'
      }
    })

    @token = auth_response["access_token"]
  end

  def search(query)
    HTTParty.get("https://api.twitter.com/1.1/search/tweets.json?q=#{query}&count=250", {
      :headers => {
        'Authorization' => "Bearer #{@token}"
      }
    }).parsed_response["statuses"]
  end
end
