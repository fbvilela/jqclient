class Requirement < ActiveResource::Base
	self.site = Rails.configuration.idashboard_url
	self.prefix = "/api/contacts/:contact_id/"
	self.element_name = 'requirement'
  self.format = :json

  def self.token=(token)
    self.headers['authorization'] = 'Bearer ' + token
  end 	
  def self.suburbs_serviced(token=nil)
    conn = Faraday.new(:url => Rails.configuration.idashboard_url) 
      
    response = conn.get do |req|
      req.url '/api/suburbs_serviced'
      req.headers['authorization'] = "Bearer #{token}"
    end
    
    json = JSON.parse(response.body)
    postal_array = json['agency']['postal_areas']
    
    postal_array.collect do |element|
      code, name = element.strip.split(',')      
      FunkyStruct.new(code: code, name: name )
    end
          
  end
end