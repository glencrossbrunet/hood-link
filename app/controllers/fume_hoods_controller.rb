class FumeHoodsController < ApplicationController
  before_filter :authenticate_admin
  
  respond_to :json
  
  def index
    fume_hoods = organization.fume_hoods
		json = fume_hoods.map { |fh| serialize(fh) }
		render json: json
  end
	
	private 
	
	def serialize(fume_hood)
		fume_hood.attributes.merge(metadata: fume_hood.metadata)
	end
  
end