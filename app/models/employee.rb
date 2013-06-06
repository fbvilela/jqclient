class Employee < ActiveResource::Base
	self.site = Rails.configuration.idashboard_url
	self.prefix = "/api/"
  self.collection_name = "employees"
	self.element_name = 'employee'
  self.format = :json

  def self.token=(token)
    self.headers['authorization'] = 'Bearer ' + token
  end
  
  def self.me
    collection_name = 'me'
    find(:all)
  end 	
  
  def vendors
    vendors = self.get(:vendors)['listings']
    to_vendor_landlor_array(vendors)    
  end
  
  def landlords
    vendors = self.get(:landlords)['listings']
    to_vendor_landlor_array(vendors)    
  end
  
  def to_vendor_landlor_array( object_array )
     object_array.collect do |object|
       vendor_landlord = FunkyStruct.new( listing: nil, contact: nil )
       vendor_landlord.contact = object['listing'].delete('contact')
       vendor_landlord.listing = object['listing']
       vendor_landlord       
     end   
  end
  
end