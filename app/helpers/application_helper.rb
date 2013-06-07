module ApplicationHelper
  
  
  def contact_categories
    Contact.categories(session[:access_token]).collect do |cat|
      [cat.name, cat.id]
    end
  end
  
  def suburbs_serviced
    Requirement.suburbs_serviced(session[:access_token]).collect do |sub|
      [sub.name, "#{sub.code},#{sub.name}"]  
    end  
  end
end
