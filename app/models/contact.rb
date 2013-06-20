class Contact < ActiveResource::Base
  #include HTTParty
  #base_uri Rails.configuration.idashboard_url + '/api'
  
  self.site = Rails.configuration.idashboard_url
  self.prefix = "/api/"
  self.element_name = 'contact'
  self.collection_name = 'contacts'
  #self.format = :json
  @@token = nil
  attr_accessor :contact_attribute_ids
  attr_accessor :phone_numbers_attributes
  
  def self.token=(arg)
  	self.headers['authorization'] = "Bearer #{token}" unless arg.blank? 
    @@token = arg 
  end
  
  def self.token 
    @@token
  end
  
  def token
    @@token
  end
  
  def self.categories
    
    conn = Faraday.new(:url => Rails.configuration.idashboard_url) 
      
    response = conn.get do |req|
      req.url '/api/contact_categories'
      req.headers['authorization'] = "Bearer #{token}" if token
    end
    
    json = JSON.parse(response.body)
    category_array = json['agency']['contact_categories']
    category_array.collect do |element|
      cat = element['contact_category']
      FunkyStruct.new(code: cat['code'], name: cat['name'] , id: cat['id'] )
    end
  end
  
  def add_note(text,author)
    params = { :contact => { :notes_attributes => [ {:note_body => text, :date_added => Time.now, :author => author} ]
      }
    }
    conn = Faraday.new(:url => Rails.configuration.idashboard_url) 
    
    response = conn.put do |req|
      req.url "/api/contacts/#{self.id}"
      req.headers['authorization'] = "Bearer #{token}" if token
      req.params = params
    end
    
    response.status == 200    
  end
  
  def notes
    notes_array = self.get(:notes)['contact_notes']  
    notes_array.collect do |element|
      note = element['contact_note']
      FunkyStruct.new(author: note['author'], note_body: note['note_body'], date_added: note['date_added'], id: note['id'])
    end
  end
  
  def to_my_params
    { 
      :contact => 
      {
        first_name: self.first_name, last_name: self.last_name, contact_attribute_ids: self.contact_attribute_ids, email: self.email,
        :phone_numbers_attributes => { self.phone_numbers_attributes.delete("id").to_sym  =>  self.phone_numbers_attributes }
       } 
    }
  end
  
  def self.search(arg)
    conn = Faraday.new(:url => Rails.configuration.idashboard_url)
    response = conn.get do |req|
      req.url "/api/search_contacts"
      req.headers['authorization'] = "Bearer #{token}" if token
      req.params = {search: arg, per_page: "50"}
    end    
    if response.status == 200
      JSON.parse( response.body )['results']['contacts'].collect do |element|
        find( element['contact']['id'])
      end
    else
      []
    end
  end
  
  def save
    self.new_record? ? super : faraday_update
  end
  
  def faraday_update()
    conn = Faraday.new(:url => Rails.configuration.idashboard_url)   
    response = conn.put do |req|
      req.url "/api/contacts/#{self.id}"
      req.headers['authorization'] = "Bearer #{token}" if token
      req.params = self.to_my_params
    end
    response.status == 200
  end
    
end

class ActiveResource::Base
def self.instantiate_collection(collection, prefix_options = {})
          puts "instantiate collection from my patch..."
          collection = collection["contacts"]
      
          collection.collect! { |record| instantiate_record(record, prefix_options) }
 end
end