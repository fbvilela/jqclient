class Contact < ActiveResource::Base
  #include HTTParty
  #base_uri Rails.configuration.idashboard_url + '/api'
  
  self.site = Rails.configuration.idashboard_url
  self.prefix = "/api/"
  self.element_name = 'contact'
  self.collection_name = 'contacts'
  #self.format = :json
  
  attr_accessor :contact_attribute_ids
  attr_accessor :phone_numbers_attributes
  
  def self.token=(token)
  	self.headers['authorization'] = 'Bearer ' + token
  end
  
  def self.categories(token=nil)
    
    conn = Faraday.new(:url => Rails.configuration.idashboard_url) 
      
    response = conn.get do |req|
      req.url '/api/contact_categories'
      req.headers['authorization'] = "Bearer #{token}"
    end
    
    json = JSON.parse(response.body)
    category_array = json['agency']['contact_categories']
    category_array.collect do |element|
      cat = element['contact_category']
      FunkyStruct.new(code: cat['code'], name: cat['name'] , id: cat['id'] )
    end
  end
  
  def add_note(text,author, token=nil)
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
  
  #def save
  #  self.new_record? ? super : faraday_update
  #end
  
  #  NOT YET BEING USED.
  def faraday_update(params)
    
    puts "inspecting params"
    params.delete("id")
    puts params.inspect
    
    puts "***********************************"

    conn = Faraday.new(:url => Rails.configuration.idashboard_url)   
    response = conn.put do |req|
      req.url "/api/contacts/#{self.id}"
      #req.headers['authorization'] = "Bearer #{token}" if 
      req.params = params
    end
    puts response.inspect
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