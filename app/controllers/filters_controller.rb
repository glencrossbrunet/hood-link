class FiltersController < ApplicationController
  before_filter :authenticate_admin
  respond_to :json
  
  def index
    render json: organization.filters.to_json
  end
  
  def create
    @filter = organization.filters.build(filter_params)
    persist
  end
  
  def update
    @filter = organization.find(params[:id])
    @filter.assign_attributes(filter_params)
    persist
  end
  
  def destroy
    @filter = organization.find(params[:id])
    @filter.destroy
    render json: @filter.to_json
  end
  
  private
  
  def persist
    if @filter.save
      render json: @filter.to_json
    else
      render json: @filter.errors.full_messages, status: 422
    end
  end
  
  def filter_params
    params.permit(:key)
  end  
end