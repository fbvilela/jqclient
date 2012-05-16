# Example usage:
#
#   class Account < ActiveResource::Base
#     self.site = "http://localhost:3000"
#   end
#
#   consumer = Consumer.new( user.access_token, Account )
#   consumer.find(1) # => equivalent to Account.find(1), but with OAuth

class Consumer
  attr_accessor :klass, :token

  def initialize(token, resource_klass)
    self.token = token
    self.klass = Class.new(resource_klass) do
      @token = token
      
      self.headers['Authorization'] = "Token token=#{Rails.configuration.app_secret}"
              
      @connection = Class.new(ActiveResource::Connection) {
        attr_accessor :token
        
        def path_with_token(path)
          path.include?("?") ?
            path + "&access_token=#{token}" :
            path + "?access_token=#{token}"
        end
        
        %w( get delete head ).each do |verb|
          alias_method "#{verb}_without_oauth", verb
          define_method verb do |path, headers={}|
            send "#{verb}_without_oauth", path_with_token(path), headers
          end
        end
        
        %w( put post ).each do |verb|
          alias_method "#{verb}_without_oauth", verb
          define_method verb do |path, body='', headers={}|
            send "#{verb}_without_oauth",
                 path_with_token(path),
                 body,
                 headers
          end
        end
      }.new(self.site, format)
      
      @connection.token = token
    end
    
    %w( element_name collection_name ).each do |attribute|
      self.klass.send "#{attribute}=", resource_klass.send(attribute)
    end
  end
  
  def method_missing(method, *args)
    klass.send method, *args if klass && klass.respond_to?(method)
  end
end