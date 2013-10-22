# == Schema Information
#
# Table name: filters
#
#  id              :integer          not null, primary key
#  key             :string(255)      not null
#  organization_id :integer          not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Filter < ActiveRecord::Base
  belongs_to :organization
  
  validates_presence_of :key, :organization_id
  validates_uniqueness_of :key, scope: :organization_id, case_sensitive: false
end
