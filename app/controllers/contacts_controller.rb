class ContactsController < ApplicationController
  
  before_filter :set_token, only: [:create,:update, :vendors, :landlords, :search, :add_note]
  before_filter :load_contact, only: [:edit,:update, :add_note]
  before_filter :check_auth, except: [:token]
  before_filter :require_premium, only: [:new, :edit, :add_note]
  
  
  #caches_action :landlords, :expires_in => 300.seconds, :unless_exist => true
  #caches_action :vendors, :expires_in => 300.seconds, :unless_exist => true
  
  
  def set_token
    Employee.token = session[:access_token]
  	Contact.token = session[:access_token]
    Requirement.token = session[:access_token]
  end
  
  def load_contact
    @contact = Contact.find(params[:id])
  end
  
  def add_note
    if params['note'] && @contact.add_note(params['note'], current_user.name)
      flash[:notice] = "Note added!" 
      redirect_to page_path("menu")
    else
      render
    end
  end
  
  def search
    @contacts = params[:search].split.collect do |param| 
      Contact.search(param)
    end.flatten.uniq
    
    respond_to do |format|
      format.html{ render 'index' }
      format.js      
    end
  end
  
  def index
    @page_name = "Contacts"
  end
  
  def new 
    phone_numbers_attributes = {name: nil, number: nil }
    @contact = Contact.new(first_name: nil, contact_attribute_ids: nil, last_name: nil, email: nil, phone_numbers_attributes: phone_numbers_attributes )
  end
  
  def edit
    # do nothing just render
  end
  
  def update

    note = params["note"]
    @contact.attributes = params['contact']
    @contact.id = params['id']
    @contact.contact_attribute_ids = [params['contact']['contact_attribute_ids']]
    @contact.phone_numbers_attributes = params['contact']['phone_numbers_attributes']

    if @contact.save
      unless note.blank? 
        @contact.add_note(note,current_user.name)
      end 
      flash[:notice] = "Contact updated!"
      redirect_to page_path("menu")
    else
      flash[:notice] = "problem updating the contact"
      redirect_to edit_contact_path(id: @contact.id)
    end
  end
  
  def vendors
    @page_name = "Vendors"
    @current_user_id = current_user.id
    @vendors_landlords = Rails.cache.fetch("#{current_user.id}_vendors", expires_in: 300.seconds) do
      current_user.vendors
    end
    respond_to do |format|
      format.html{ render "vendors_landlords" }
      format.js
    end
  end
  
  def landlords
    @page_name = "Landlords"
    @current_user_id = current_user.id
    @vendors_landlords = current_user.landlords
    respond_to do |format|
      format.html{ render "vendors_landlords" }
      format.js
    end
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