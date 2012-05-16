class Contact < ActiveResource::Base
  
  self.site = Rails.configuration.idashboard_url
  self.prefix = "/api/"
  self.element_name = 'contact'
  self.collection_name = 'contacts'
  self.format = :json
  self.headers['Authorization'] = 'Bearer jRv495jDNhHJoY8R6zwzeox4KcgFaBNIVviBtqpm'
  def self.token=(token)
  	self.headers['authorization'] = 'Bearer ' + token
  end

end