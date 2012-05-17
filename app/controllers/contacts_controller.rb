class ContactsController < ApplicationController

  def index
  	Contact.token = session[:access_token]
    temps = Contact.find(:all)
    @contacts = temps.collect{ |t| Contact.find(t.id) }
  end

  def create 
  	puts session[:access_token]
  	Contact.token = session[:access_token]
    Requirement.token = session[:access_token]
    
    min, max = params['requirement_price'].split("_")
    params['requirement']['min_price'] = min 
    params['requirement']['max_price'] = max

    contact = Contact.new( params['contact'] )
    
  	if contact.save
      unless params['requirement']['name'].blank? 
        requirement = Requirement.new(params['requirement'])
        requirement.prefix_options = {:contact_id => contact.id}
        requirement.save
      end
  	  flash[:notice] = "#{contact.name} added to iDashboard!"
  	  redirect_to "/contacts/index"
    else
      flash[:notice] = "Booo, contact was not created :("
      redirect_to "/contacts/new"
    end
  end

end