require 'multi_json'

module RspecHelpers
  
  def json
    MultiJson.load(response.body)
  end
    
end