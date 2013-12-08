class FiltersController < ApplicationController
  before_filter :authenticate_admin
  before_filter :find_filter, only: [ :update, :destroy ]
  respond_to :json
  
  def index
    render json: filters.to_json
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
    render json: @filter.to_json
  end
  
  private
  
  def find_filter
    @filter = filters.find(params[:id])
  end
  
  def filters
    organization.filters
  end
  
  def filter_params
    params.permit(:key)
  end
end