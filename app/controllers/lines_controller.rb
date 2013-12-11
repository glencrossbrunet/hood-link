class LinesController < ApplicationController
  before_filter :authenticate_member
  before_filter :find_line, only: [ :update, :destroy ]
  respond_to :json
  
  def index
    render json: lines
  end
  
  def create
    persist lines.build(line_params)
  end
  
  def update
    @line.assign_attributes line_params
    persist @line
  end
  
  def destroy
    @line.destroy
    render json: @line
  end
  
  private
  
  def find_line
    @line = lines.find(params[:id])
  end
  
  def line_params(defaults = {})
    filters = params.fetch(:filters, {}).permit(*filter_keys)
    attrs = params.permit(:name, :visible)
    attrs.merge(filters: filters)
  end
end