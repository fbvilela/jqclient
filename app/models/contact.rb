class Contact < ActiveResource::Base
  #include HTTParty
  #base_uri Rails.configuration.idashboard_url + '/api'
  UNAUTHORIZED = "Unauthorized"
  self.site = Rails.configuration.idashboard_url
  self.prefix = "/api/"
  self.element_name = 'contact'
  self.collection_name = 'contacts'
  self.include_root_in_json = true
  #self.format = :json
  @@token = nil
  attr_accessor :contact_attribute_ids
  attr_accessor :phone_numbers_attributes
  
  cattr_accessor :static_headers
  self.static_headers = headers
  
  def self.headers
    new_headers = static_headers.clone
    new_headers['authorization'] = "Bearer #{token}"
    new_headers
  end
  
  def self.token=(arg)
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
  
  def phone_id
    if self.attributes['phone_numbers_attributes'].is_a?(Hash)
      self.attributes['phone_numbers_attributes']['id'] || "_new"
    else
      self.attributes['phone_numbers_attributes'].attributes.delete("id") || "_new"
    end
  end
  
  def phone_attributes
    if self.attributes['phone_numbers_attributes'].is_a?(Hash)
      self.attributes['phone_numbers_attributes']
    else
      self.attributes['phone_numbers_attributes'].attributes
    end
  end
  
  def to_my_params
    x = { 
      :contact => 
      {
        first_name: self.first_name, last_name: self.last_name, contact_attribute_ids: ([self.attributes['contact_attribute_ids']] || [nil]) , email: self.email,
        phone_numbers_attributes: { phone_id.to_s.to_sym  =>  phone_attributes }
       } 
    }
    puts "returning #{x}"
    x
  end
  
  def self.search(arg)
    conn = Faraday.new( :url => Rails.configuration.idashboard_url )
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
      raise UNAUTHORIZED
    end
  end
  
  def save
    self.new_record? ? faraday_create : faraday_update
  end
  
  def faraday_create
    puts "on faraday create"
    conn = Faraday.new(:url => Rails.configuration.idashboard_url)   
    response = conn.post do |req|
      req.url "/api/contacts"
      req.headers['authorization'] = "Bearer #{token}" if token
      req.params = self.to_my_params
    end
    if response.status == 201
      id = JSON.parse( response.body )['contact']['id']
      self.attributes = self.class.find(id).attributes
    end
    
  end
  
  def faraday_update()
    conn = Faraday.new(:url => Rails.configuration.idashboard_url)   
    response = conn.put do |req|
      req.url "/api/contacts/#{self.id}"
      req.headers['authorization'] = "Bearer #{token}" if token
      req.params = self.to_my_params
    end
    response.status == 200 ? true : (raise UNAUTHORIZED)
  end
    
end

class ActiveResource::Base
def self.instantiate_collection(collection, prefix_options = {})
          puts "instantiate collection from my patch..."
          collection = collection["contacts"]
      
          collection.collect! { |record| instantiate_record(record, prefix_options) }
 end
end