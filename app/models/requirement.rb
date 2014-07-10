class Requirement < ActiveResource::Base
	self.site = Rails.configuration.idashboard_url
	self.prefix = "/api/contacts/:contact_id/"
	self.element_name = 'requirement'
  self.format = :json
  self.include_root_in_json = true
  @@token = nil
  def self.token=(token)
    self.headers['authorization'] = "Bearer #{token}"
    @@token = token 
  end 	
  
  def token
    @@token
  end
  
  def self.token
    @@token
  end
  
  def self.suburbs_serviced
    conn = Faraday.new(:url => Rails.configuration.idashboard_url) 
      
    response = conn.get do |req|
      req.url '/api/suburbs_serviced'
      req.headers['authorization'] = "Bearer #{token}" if token
    end
    
    json = JSON.parse(response.body)
    postal_array = json['agency']['postal_areas']
    
    postal_array.collect do |element|
      code, name = element.strip.split(',')      
      FunkyStruct.new(code: code, name: name )
    end
          
  end
end