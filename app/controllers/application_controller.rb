class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from Exception do |exception| 
      Rails.logger.error "Exception #{exception.class}: #{exception.message}"
      puts exception.message
      render_login
  end

  def require_premium
    unless session[:access_token].blank? 
      redirect_to page_path("premium") unless ( current_user.is_premium == "true" rescue false) 
    end
  end
  
  def render_login 
    respond_to do |format|
      format.html{ redirect_to page_path("index")}
      format.js{ render js: %(window.location.href='/pages/index') and return }
    end
  end
  
  def token
    unless params[:token].blank? 
      puts "setting the token to #{params[:token]}"
      session[:access_token] = params[:token]
      Employee.token = session[:access_token]
    	Contact.token = session[:access_token]
      Requirement.token = session[:access_token]
      redirect_to page_path("menu")
    end  
  end

  def check_auth
    if request.xhr? 
      if session[:access_token].blank?
       render js: %(window.location.href='/pages/index') and return
     end
    else
      redirect_to page_path('index') if session[:access_token].blank?
    end  
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
