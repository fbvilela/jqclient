class FunkyStruct < OpenStruct

  
  def method_missing(name, *args)
    self[name]
  end

end