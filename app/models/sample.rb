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
  
  def self.avg(sample_metric, datetime_range)
    samples = where(sample_metric_id: sample_metric.id)
    samples = samples.where(sampled_at: datetime_range)
    samples = samples.order('sampled_at ASC')
          
    total_seconds = datetime_range.end.to_i - samples.first.sampled_at.to_i    
    average = 0.0
    
    samples.each_cons(2) do |start, stop|
      seconds = stop.sampled_at.to_i - start.sampled_at.to_i
      average += (seconds.to_f / total_seconds) * start.value
    end

    seconds = datetime_range.end.to_i - samples.last.sampled_at.to_i
    average += (seconds.to_f / total_seconds) * samples.last.value
    
    average
  end
end
