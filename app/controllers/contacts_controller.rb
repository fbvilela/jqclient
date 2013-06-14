class ContactsController < ApplicationController
  
  before_filter :set_token, only: [:create,:update]
  before_filter :load_contact, only: [:edit,:update]
  
  def set_token
  	Contact.token = session[:access_token]
    Requirement.token = session[:access_token]
  end
  
  def load_contact
    @contact = Contact.find(params[:id])
  end
  
  def index
  	Contact.token = session[:access_token]
    temps = Contact.find(:all) # /api/contacts
    @contacts = temps.collect{ |t| Contact.find(t.id) } # /api/contacts/:id/
  end
  
  def new 
    phone_numbers_attributes = {name: nil, number: nil }
    @contact = Contact.new(first_name: nil, contact_attribute_ids: nil, last_name: nil, email: nil, phone_numbers_attributes: phone_numbers_attributes )
    
  end
  
  def edit
    # do nothing just render
  end
  
  def update
    params['contact']['contact_attribute_ids'] = [params['contact']['contact_attribute_ids']]
    note = params["note"]
    if @contact.faraday_update( params )
      unless note.blank? 
        @contact.add_note(note,current_user.name)
      end 
      flash[:notice] = "success"
      redirect_to page_path("menu")
    else
      flash[:notice] = "problem updating the contact"
      redirect_to edit_contact_path(id: @contact.id)
    end
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
  	
    
    params['contact']['contact_attribute_ids'] = [params['contact']['contact_attribute_ids']]
    note = params["note"]
    contact = Contact.new( params['contact'] )
  	if contact.save
      unless note.blank? 
        contact.add_note(note, current_user.name)
      end
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