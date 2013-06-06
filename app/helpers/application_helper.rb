module ApplicationHelper
  
  
  def contact_categories
    Contact.categories(session[:access_token]).collect do |cat|
      [cat.name, cat.id]
    end
  end
end
