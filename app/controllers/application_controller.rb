class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_auth


  def check_auth
    #redirect_to page_path('index') unless session[:access_token]
  end

  def oauth_client
    OAuth2::Client.new( APPLICATION_ID, APPLICATION_SECRET, :site => SITE_URL)
  end

  
end
