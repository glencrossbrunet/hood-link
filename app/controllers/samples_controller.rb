class SamplesController < ApplicationController  
  skip_before_action :verify_authenticity_token, only: [ :create ]
  before_filter :authenticate_organization, only: [ :create ]
  respond_to :json
  
  def index
    date = Date.parse params.require(:date)
    interval = 1.hour
    if date < Date.today
      render json: organization.daily_intervals(date, interval)
    else
      render json: { error: 'date must be in the past' }, status: 400
    end
  end
  
  
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
    @sample_metric ||= SampleMetric.where(sample_metric_params).first_or_create
  end
  
  def fume_hood
    @fume_hood ||= fume_hoods.where(fume_hood_params).first_or_create
  end
  
  def sample_params
    params.require(:sample).permit(:unit, :value, :source, :sampled_at)
  end
  
  def fume_hood_params
    params.require(:fume_hood).permit(:external_id)
  end
  
  def sample_metric_params
    params.require(:sample_metric).permit(:name)
  end
  
  def authenticate_organization
    token = params.require(:organization).fetch(:token) rescue params.fetch(:token)
    if organization.token != token
      render json: { error: 'token does not match for organization' }, status: 403
    end
  end
end