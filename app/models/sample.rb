# == Schema Information
#
# Table name: samples
#
#  id               :integer          not null, primary key
#  fume_hood_id     :integer          not null
#  sample_metric_id :integer          not null
#  unit             :string(255)
#  value            :float            not null
#  source           :string(255)
#  sampled_at       :datetime         not null
#  created_at       :datetime
#  updated_at       :datetime
#
require 'csv'

class Sample < ActiveRecord::Base
  scope :flow_rate, -> { where(sample_metric: SampleMetric.where(name: 'Flow Rate').first_or_create) }
  scope :percent_open, -> { where(sample_metric: SampleMetric.where(name: 'Percent Open').first_or_create) }
  
  belongs_to :fume_hood
  belongs_to :sample_metric
  
  validates_presence_of :fume_hood_id, :sample_metric_id, :value, :sampled_at
  
  extend SparseCollection
  
  def self.avg(datetime_range)
    sparse(:sampled_at).for(datetime_range).average_left(:value)
  end
  
  def self.most_recent
    sparse(:sampled_at).find_left
  end
  
  # [ { sampled_at: datetime, value: float, unit: string }, ... ]
  def self.daily_intervals(day, interval)
    samples = sparse(:sampled_at).for(period_from day).intervals_left(interval)
    samples.map { |s| s.slice(:sampled_at, :value, :unit) }
  end
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
			csv << %w(fume_hood_id sample_name sampled_at value unit source) 
      includes(:fume_hood, :sample_metric).find_each do |s|
				csv << [ s.fume_hood.external_id, s.sample_metric.name, s.sampled_at, s.value, s.unit, s.source ]
      end
    end
  end
  
  private
  
  def self.period_from(day)
    datetime = day.to_datetime
    datetime.beginning_of_day..datetime.end_of_day
  end
end
