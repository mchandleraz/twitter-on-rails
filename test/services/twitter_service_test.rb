require 'test_helper'

class TwitterServiceTest < ActiveSupport::TestCase
  test 'returns an Array of tweets' do
    # This will return false if it fails
    tweets = TwitterService.new({
      key: Rails.application.credentials.twitter[:client_key],
      secret: Rails.application.credentials.twitter[:client_secret]
    }).search("rails")

    assert_kind_of(Array, tweets)
  end
end