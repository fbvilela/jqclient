class ContactsController < ApplicationController

  def index
  	Contact.token = session[:access_token]
    temps = Contact.find(:all)
    @contacts = temps.collect{ |t| Contact.find(t.id) }
  end

  def create 
  	puts session[:access_token]
  	Contact.token = session[:access_token]
    
  	contact = Contact.new
  	contact.first_name = params[:contact][:first_name]
  	contact.last_name = params[:contact][:last_name]
  	contact.email = params[:contact][:email]
  	if contact.save
  	  flash[:notice] = "OMG it works! check idashboard... "
  	  redirect_to "/contacts/index"
    else
      flash[:notice] = "Booo, contact was not created :("
      redirect_to "/contacts/new"
    end
  end

end