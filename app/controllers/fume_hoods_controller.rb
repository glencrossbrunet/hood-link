require 'csv'

class FumeHoodsController < ApplicationController
  before_filter :authenticate_admin, except: [ :index, :samples ]
  respond_to :json
  
  def index
		render json: fume_hoods.order('external_id ASC')
  end
  
  def create
    persist fume_hoods.build(params.permit(:external_id))
  end
  
  def update
    @fume_hood = fume_hoods.find(params[:id])
    @fume_hood.assign(fume_hood_params)
    persist @fume_hood
  end
	
	def display
		@fume_hood = fume_hoods.find(params[:id])
		metric_id = SampleMetric.where(name: 'Percent Open').first_or_create.id
		if @fume_hood.display.present?
			DisplayWorker.update_display_for(@fume_hood, metric_id, nil)
		end
		render json: { status: 200 }
	end
  
  def upload
    csv = params.fetch(:csv)
    CSV.parse(csv, headers: true).each do |row|
      upload_from row.to_hash
    end
    render json: { status: 200 }
  end
	
	private
    
  def upload_from(hash)
    key_value_strip! hash
    natural_key = hash['external_id'] || hash['hood_id']
    fume_hood = fume_hoods.where(external_id: natural_key).first_or_initialize
    fume_hood.update(data: hash.except('external_id', 'hood_id'))
  end
  
  def key_value_strip!(hash)
    hash.keys.each do |key|
      value = hash[key]
      hash.delete key
      hash[key.strip] = value.strip
    end
  end
  
  def metadata
    Hash[ data_keys.zip([''] * data_keys.length) ]
  end
  
  def fume_hood_params
    data = params.fetch(:data).permit(*filter_keys)
    attrs = params.permit(:external_id)
    attrs[:data] = data
    attrs
  end  
end