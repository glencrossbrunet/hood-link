class FiltersController < ApplicationController
  before_filter :authenticate_admin
  before_filter :find_filter, only: [ :update, :destroy ]
  respond_to :json
  
  def index
    render json: filters
  end
  
  def create
    @filter = filters.build(filter_params)
    persist @filter
  end
  
  def update
    @filter.assign_attributes(filter_params)
    persist @filter
  end
  
  def destroy
    @filter.destroy
    render json: @filter
  end
  
  private
  
  def find_filter
    @filter = filters.find(params[:id])
  end
  
  def filter_params
    params.permit(:key)
  end
end