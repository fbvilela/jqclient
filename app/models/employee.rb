class Employee < ActiveResource::Base
	self.site = Rails.configuration.idashboard_url
	self.prefix = "/api/"
  self.collection_name = "employees"
	self.element_name = 'employee'
  self.format = :json
  @@token = nil
  
  cattr_accessor :static_headers
  self.static_headers = headers
  
  def self.token=(arg)
    @@token = arg 
  end
  
  def self.headers
    new_headers = static_headers.clone
    new_headers['authorization'] = "Bearer #{token}"
    new_headers
  end
  
  def self.token 
    @@token
  end
  
  def token
    @@token
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
       vendor_landlord = OpenStruct.new( listing: nil, contact: nil )
       vendor_landlord.contact = object['listing'].delete('contact')
       vendor_landlord.listing = object['listing']
       vendor_landlord       
     end.sort_by{ |i| i.contact['name']}   
  end
  
end


class ActiveResource::Base
def self.instantiate_collection(collection, prefix_options = {})
          puts "instantiate collection from my patch..."
          collection = collection["employees"]      
          collection.collect! { |record| instantiate_record(record, prefix_options) }
 end
end