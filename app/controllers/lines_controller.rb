class LinesController < ApplicationController
  before_filter :authenticate_member
  before_filter :find_line, only: [ :update, :destroy ]
  respond_to :json
  
  def index
    render json: lines.to_json
  end
  
  def create
    @line = lines.build(line_params)
    persist @line
  end
  
  def update
    @line.assign_attributes line_params
    persist @line
  end
  
  def destroy
    @line.destroy
    render json: @line.to_json
  end
  
  private
  
  def lines
    current_user.lines.where(organization: organization)
  end
  
  def find_line
    @line = lines.find(params[:id])
  end
  
  def filter_keys
    @filter_keys ||= organization.filters.pluck(:key)
  end
  
  def line_params(defaults = {})
    filters = params.fetch(:filters, {}).permit(*filter_keys)
    attrs = params.permit(:name, :visible)
    attrs.merge(filters: filters)
  end
end