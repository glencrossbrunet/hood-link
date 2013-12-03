# == Schema Information
#
# Table name: fume_hoods
#
#  id              :integer          not null, primary key
#  organization_id :integer          not null
#  external_id     :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#  data            :json             default({})
#

class FumeHood < ActiveRecord::Base
  belongs_to :organization
  
  validates_presence_of :external_id, :organization_id
  validates_uniqueness_of :external_id
	
	has_many :samples

  def display
    keys = %w(mac_address gateway_id)
    if keys.all? { |key| data[key].present? }
      HashWithIndifferentAccess.new data.slice(*keys)
    else
      nil
    end
  end
  
  def as_json(options = {})
    attributes.slice(* %w(id external_id data updated_at))
  end
  
  def data=(hash)
    write_attribute :data, data.merge(hash)
  end
  
  # outputs:
  #
  #  [ { sampled_at: datetime, value: float } ]
  #
  def periodic_samples(interval, conditions = {})
    period = conditions[:sampled_at]
    sparse_samples = samples.where(conditions).sparse(:sampled_at)
    if period.present?
      sparse_samples.starting(period.begin).ending(period.end)
    end
    sparse_samples.regularize_left(interval, :value)
  end
  
  # outputs:
  #
  #  { datetime => { 'hood-id-1' => float, 'hood-id-2 => float, ... }  }
  #
  # then
  #
  #  [ { sampled_at: datetime, 'hood-id-1' => float, 'hood-id-2' => float, etc } ]
  #
  def self.periodic_samples(interval, conditions = {})
    records = Hash.new{ |h, k| h[k] = {} }
    find_each do |fume_hood|
      samples = fume_hood.periodic_samples(interval, conditions)
      samples.each do |sample|
        datetime = sample[:sampled_at]
        records[datetime][fume_hood.external_id] = sample[:value]
      end
    end    
    records.map do |datetime, values|
      { sampled_at: datetime }.merge Hash[ values.sort_by{ |k, v| k } ]
    end
  end
  
end
