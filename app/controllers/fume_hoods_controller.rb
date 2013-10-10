class FumeHoodsController < ApplicationController
  before_filter :authenticate_admin
  
  respond_to :json
  
  def index
    fume_hoods = organization.fume_hoods
    respond_with(fume_hoods)
  end
  
end