require "cgi"
require "base64"

class TwitterService
  def initialize(config)
    # URL encode the consumer key and the consumer secret
    consumer_key = CGI::escape(config[:key])
    consumer_secret = CGI::escape(config[:secret])
    # Concatenate the encoded key, a colon, and the encoded secret
    key_and_secret = "#{consumer_key}:#{consumer_secret}"

    # auth_response will be {"token_type":"bearer","access_token":"TOKEN"}
    auth_response = HTTParty.post('https://api.twitter.com/oauth2/token', {
      :headers => {
        # Twitter requires that the key_and_secret be base64 encoded.
        # Using 'strict_encode' because 'encode' adds line-feeds
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
