class LinesController < ApplicationController
  before_filter :authenticate_member
  before_filter :find_line, only: [ :update, :destroy ]
  respond_to :json
  
  def index
    render json: lines.where(organization: organization).to_json
  end
  
  def create
    @line = lines.build(line_params organization: organization)
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
    current_user.lines
  end
  
  def find_line
    @line = lines.find(params[:id])
  end
  
  def line_params(defaults = {})
    params.permit(:filters, :visible).merge(defaults)
  end
end