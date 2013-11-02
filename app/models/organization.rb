# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  subdomain  :string(255)
#  created_at :datetime
#  updated_at :datetime
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
end
