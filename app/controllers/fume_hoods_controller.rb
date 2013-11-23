require 'csv'

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
  
  def upload
    csv = params.fetch(:csv)
    data = CSV.parse(csv, headers: true)
    data.each do |row|
      upload_from row.to_hash
    end
    render json: { status: 200 }
  end
	
	private
  
  def upload_from(hash)
    attrs = attrs_from hash
    natural_key = attrs['external_id'] || attrs['hood_id']
    query = organization.fume_hoods.where(external_id: natural_key)
    fume_hood = query.first_or_initialize
    fume_hood.data = attrs.except('external_id')
    fume_hood.save
  end
  
  def attrs_from(hash)
    attrs = {}
    hash.each { |k, v| attrs[k.strip] = v.strip }
    attrs
  end
  
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