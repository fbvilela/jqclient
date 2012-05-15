class ApplicationController < ActionController::Base
  protect_from_forgery


  def oauth_client
    OAuth2::Client.new( APPLICATION_ID, APPLICATION_SECRET, :site => SITE_URL)
  end

  
end
