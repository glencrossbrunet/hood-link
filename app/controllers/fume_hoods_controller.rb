class FumeHoodsController < ApplicationController
  before_filter :authenticate_admin
  
  respond_to :json
  
  def index
    fume_hoods = organization.fume_hoods
    json = fume_hoods.to_json
		render json: json
  end
  
  def create
    @fume_hood = organization.fume_hoods.build(params.permit(:external_id))
    if @fume_hood.save
      render json: @fume_hood.reload.to_json
    else
      render json: @fume_hood.errors.to_json, status: 422
    end
  end
  
  def update
    @fume_hood = organization.fume_hoods.find(params[:id])
    if @fume_hood.update_attributes(fume_hood_params)
      render json: @fume_hood.reload.to_json
    else
      render json: @fume_hood.errors.to_json, status: 422
    end
  end
	
	def display
		@fume_hood = organization.fume_hoods.find(params[:id])
		metric_id = SampleMetric.where(name: 'Percent Open').first_or_create.id
		if @fume_hood.display.present?
			DisplayWorker.update_display_for(@fume_hood, metric_id, nil)
		end
		render json: { status: 200 }
	end
	
	private
  
  def data_keys
    @data_keys ||= organization.filters.pluck(:key)
  end
  
  def metadata
    keys = data_keys
    Hash[ keys.zip([''] * keys.length) ]
  end
  
  def fume_hood_params
    data = params.fetch(:data).permit(*data_keys)
    attrs = params.permit(:external_id)
    attrs[:data] = data
    attrs
  end  
end