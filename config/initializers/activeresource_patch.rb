
class ActiveResource::Base
def self.instantiate_collection(collection, prefix_options = {})
          puts "instantiate collection from my patch..."
          collection = collection["contacts"]
      
          collection.collect! { |record| instantiate_record(record, prefix_options) }
 end
end