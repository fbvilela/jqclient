class ContactsController < ApplicationController

  def index
  	Contact.token = session[:access_token]
    temps = Contact.find(:all) # /api/contacts
    @contacts = temps.collect{ |t| Contact.find(t.id) } # /api/contacts/:id/
  end
  
  def new 
    phone_numbers_attributes = {name: nil, number: nil }
    @contact = Contact.new(first_name: nil, contact_attribute_ids: nil, last_name: nil, email: nil, phone_numbers_attributes: phone_numbers_attributes )
    
  end
  
  def vendors
    @page_name = "Vendors"
    @vendors_landlords = current_user.vendors
    render "vendors_landlords"
  end
  
  def landlords
    @page_name = "Landlords"
    @vendors_landlords = current_user.landlords
    render "vendors_landlords"
  end

  def create 
  	Contact.token = session[:access_token]
    Requirement.token = session[:access_token]
    
    params['contact']['contact_attribute_ids'] = [params['contact']['contact_attribute_ids']]
    contact = Contact.new( params['contact'] )
  	if contact.save
      unless params['requirement']['name'].blank? 
        params['requirement']['postal_area_names'] = [params['requirement']['postal_area_names'] ]
        requirement = Requirement.new(params['requirement'])
        requirement.prefix_options = {:contact_id => contact.id}
        requirement.save
      end
      
  	  flash[:notice] = "#{contact.name} added to iDashboard!"
      flash.keep
  	  redirect_to page_path("menu")
    else
      flash[:notice] = "Booo, contact was not created :("
      redirect_to "/contacts/new"
    end
  end

end