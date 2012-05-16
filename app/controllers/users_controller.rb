require 'net/http'
class UsersController < ApplicationController
  def sign_in
  	
  	login = params[:login]
  	password = params[:password]
  	uri = URI(Rails.configuration.idashboard_url+'/oauth/token')
	res = Net::HTTP.post_form(uri, 'client_id' => Rails.configuration.app_key, 'client_secret' => Rails.configuration.app_secret, 'grant_type' => 'password', 'username' => login, 'password' => password )
	if res.code == '200'
		token = JSON.parse(res.body)['access_token']
		session[:access_token] = token
		puts "my token is #{token}"
    redirect_to "/contacts/index"
	else
		flash[:notice] = "Invalid username or password."
	end
	
  end

  def sign_out
  	session[:access_token] = nil
  	redirect_to page_path('index')
  end
end