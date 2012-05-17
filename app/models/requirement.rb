class Requirement < ActiveResource::Base
	self.site = Rails.configuration.idashboard_url
	self.prefix = "/api/contacts/:contact_id/"
	self.element_name = 'requirement'
    self.format = :json

    def self.token=(token)
  	self.headers['authorization'] = 'Bearer ' + token
  end 	
end