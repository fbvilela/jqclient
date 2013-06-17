class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_auth
  before_filter :receive_token
  
  def receive_token
    unless params[:token].blank? 
      session[:access_token] = params[:token]
    end  
  end

  def check_auth
    #redirect_to page_path('index') unless session[:access_token]
  end

  def oauth_client
    OAuth2::Client.new( APPLICATION_ID, APPLICATION_SECRET, :site => SITE_URL)
  end
  
  def current_user
    json = JSON.parse( HTTParty.get(Rails.configuration.idashboard_url+"/api/me", :headers => {"authorization" => "Bearer #{session[:access_token]}"}).body )
    Employee.new(json['employee'])
  end
  
  def record_login
    current = current_user
    login = params[:login]
    LoginHistory.create(employee_id: current.id , login: login, name: current.name)    
  end

  
end
