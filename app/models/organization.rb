# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  subdomain  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  token      :string(255)
#

class Organization < ActiveRecord::Base
  resourcify
  
  validates :name, presence: true
  validates :subdomain, uniqueness: true, 
      format: { with: /\A[a-z0-9]+(-[a-z0-9]+)*\Z/ }
  
  has_many :users, through: :roles
  has_many :fume_hoods
  has_many :filters
  has_many :samples, through: :fume_hoods
    
  def members
    users.where(roles: { name: 'member' })
  end
  
  def admins
    users.where(roles: { name: 'admin' })
  end
  
  def intervals(days, interval)
    data = Hash.new { |h, k| h[k] = [] }
    days.each do |day|
      daily_intervals(day, interval).each do |external_id, samples|
        data[external_id].concat(samples)
      end
    end
    data
  end
  
  def daily_intervals(day, interval)
    Rails.cache.fetch(cache_key day, interval) do
      fume_hoods.daily_intervals(day, interval)
    end
  end
  
  def cache_key(day, interval)
    [ "org#{id}", day.strftime('%Y%m%d'), interval.seconds.to_i ].join('_')
  end
end
