class Contact < ActiveResource::Base
  include HTTParty
  base_uri Rails.configuration.idashboard_url + '/api'
  
  self.site = Rails.configuration.idashboard_url
  self.prefix = "/api/"
  self.element_name = 'contact'
  self.collection_name = 'contacts'
  self.format = :json
  
  def self.token=(token)
  	self.headers['authorization'] = 'Bearer ' + token
  end
  
  def self.categories(token=nil)
    response = get('/contact_categories', :headers => {"authorization" => "Bearer #{token}"})
    json = JSON.parse(response.body)
    category_array = json['agency']['contact_categories']
    category_array.collect do |element|
      cat = element['contact_category']
      FunkyStruct.new(code: cat['code'], name: cat['name'] , id: cat['id'] )
    end
  end

end

class ActiveResource::Base
def self.instantiate_collection(collection, prefix_options = {})
          puts "instantiate collection from my patch..."
          collection = collection["contacts"]
      
          collection.collect! { |record| instantiate_record(record, prefix_options) }
 end
end