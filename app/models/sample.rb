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
  belongs_to :fume_hood
  belongs_to :sample_metric
  
  validates_presence_of :fume_hood_id, :sample_metric_id, :value, :sampled_at
  
  extend SparseCollection
  
  def self.avg(datetime_range)
		samples = where(sampled_at: datetime_range).order('sampled_at ASC')
		sparse_avg = samples.sparse(:sampled_at).ending(datetime_range.end).average_left(:value)
		sparse_avg || most_recent.try(:value)
  end
  
  def self.most_recent
    sparse(:sampled_at).find_left
  end
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
			csv << %w(fume_hood_id sample_name sampled_at value unit source) 
      includes(:fume_hood, :sample_metric).find_each do |s|
				csv << [ s.fume_hood.external_id, s.sample_metric.name, s.sampled_at, s.value, s.unit, s.source ]
      end
    end
  end
end
