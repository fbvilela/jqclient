module ApplicationHelper
  
  
  def contact_categories
    Contact.token = session[:access_token]
    [["Category", nil]] + Contact.categories.collect do |cat|
      [cat.name, cat.id]
    end 
  end
  
  def suburbs_serviced
    Requirement.token = session[:access_token]
    Requirement.suburbs_serviced.collect do |sub|
      [sub.name, "#{sub.code},#{sub.name}"]  
    end  
  end
end
