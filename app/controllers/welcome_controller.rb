class WelcomeController < ApplicationController
  def initialize
    super

    @twitter = TwitterService.new({
      key: Rails.application.credentials.twitter[:client_key],
      secret: Rails.application.credentials.twitter[:client_secret]
    })
  end

  def index
    @tweets = @twitter.search("reactjs")
  end
end
