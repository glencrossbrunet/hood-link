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
  
  validates :subdomain, uniqueness: true, 
      format: { with: /\A[a-z0-9]+(-[a-z0-9]+)*\Z/ }
end
