class ContactsController < ApplicationController
  
  before_filter :set_token, only: [:create,:update, :vendors, :landlords, :search, :add_note]
  before_filter :load_contact, only: [:edit,:update, :add_note]
  before_filter :check_auth, except: [:token]
  respond_to :html, :js
  #before_filter :require_premium, only: [:new, :edit, :add_note]
    
  #caches_action :landlords, :expires_in => 300.seconds, :unless_exist => true
  #caches_action :vendors, :expires_in => 300.seconds, :unless_exist => true
    
  def set_token
    Employee.token = session[:access_token]
  	Contact.token = session[:access_token]
    Requirement.token = session[:access_token]
    
    puts "setting token #{session[:access_token]}"
  end
  
  def load_contact
    @contact = Contact.find(params[:id])
  end
  
  def add_note
    if params['note']
      if !params['note'].blank? && @contact.add_note(params['note'], current_user.name)
       flash[:notice] = "Note added!" 
       redirect_to(:back)
      else 
       render status: 200
      end
    else
      render layout: false
    end
  end
  
  def search
    @contacts = params[:search].split.collect do |param| 
      Contact.search(param)
    end.flatten.uniq
    

    render partial: 'contact', collection: @contacts
      
    
  end
  
  def index

  end
  
  def new 
    phone_numbers_attributes = {name: nil, number: nil }
    @contact = Contact.new(first_name: nil, contact_attribute_ids: nil, last_name: nil, email: nil, phone_numbers_attributes: phone_numbers_attributes )
  end
  
  def edit
    @contact = Contact.find( params['id'] )
    puts "editing contact #{@contact.name}"
    render :layout => false
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
      redirect_to :back
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
    @vendors_landlords =  Rails.cache.fetch("#{current_user.id}_landlords", expires_in: 300.seconds ) do
      current_user.landlords
    end
    respond_to do |format|
      format.html{ render "vendors_landlords" }
      format.js
    end
  end

  def create 
  	params['contact']['contact_attribute_ids'] = [ params['contact']['contact_attribute_ids']  ]
    note = params["note"]
    contact = Contact.new( params['contact'] )
  	if (contact.save)
      unless note.blank? 
        puts "adding a note"
        contact.add_note(note, current_user.name)
      end
      unless params['requirement']['name'].blank? 
        puts "creating requirement"
        params['requirement']['postal_area_names'] = [params['requirement']['postal_area_names'] ]
        requirement = Requirement.new(params['requirement'])
        requirement.prefix_options = {:contact_id => contact.id}
        requirement.save
      end
      puts "deu certo..."
  	  flash[:notice] = "#{contact.name} added to iDashboard!"
      flash.keep
  	  redirect_to page_path("menu")
    else
      flash[:notice] = "Notice: Last name is required."
      redirect_to "/contacts/new"
    end
  end

end