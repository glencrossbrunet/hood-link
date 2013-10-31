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

class Sample < ActiveRecord::Base
  belongs_to :fume_hood
  belongs_to :sample_metric
  
  validates_presence_of :fume_hood_id, :sample_metric_id, :value, :sampled_at
  
  extend SparseCollection
  
  def self.avg(datetime_range)
    samples = where(sampled_at: datetime_range).order('sampled_at ASC')
    samples.sparse(:sampled_at).ending(datetime_range.end).average_left(:value)
  end
  
  def self.most_recent
    sparse(:sampled_at).find_left
  end
end
