class SamplesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authenticate_organization
  respond_to :json
  
  # requests should POST json in the following format:
  # 
  # {
  #   organization: {
  #     token: string
  #   },
  #   sample: {
  #     unit: string,
  #     value: float,
  #     source: string,
  #     sampled_at: datetime
  #   }
  #   fume_hood: { 
  #     external_id: 'string' 
  #   },
  #   sample_metric: { 
  #     name: 'string' 
  #   }
  # }
  
  def create
    attrs = sample_params.merge(sample_metric_id: sample_metric.id)
    previous_sample = sparse_samples.find_left(attrs[:sampled_at])
    
    ok = previous_sample.blank?
    ok ||= (previous_sample.value - attrs[:value].to_f).abs > 0.001
    fume_hood.samples.where(attrs).first_or_create if ok
    
    render json: { status: 200 }
  end
  
  private
  
  def sparse_samples
    fume_hood.samples.where(sample_metric_id: sample_metric.id).sparse(:sampled_at)
  end
  
  def sample_metric
    query = params.require(:sample_metric).permit(:name)
    @sample_metric ||= SampleMetric.where(query).first
  end
  
  def fume_hood
    query = params.require(:fume_hood).permit(:external_id)
    @fume_hood ||= organization.fume_hoods.where(query).first_or_create
  end
  
  #  fume_hood_id     :integer          not null
  #  sample_metric_id :integer          not null
  #  unit             :string(255)
  #  value            :float            not null
  #  source           :string(255)
  #  sampled_at  
  
  def sample_params
    params.require(:sample).permit(:unit, :value, :source, :sampled_at)
  end
  
  def authenticate_organization
    token = params.require(:organization).fetch(:token)
    if organization.token != token
      render json: { error: 'token does not match for organization' }, status: 403
    end
  end
  
end