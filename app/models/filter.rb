class Filter < ActiveRecord::Base
  belongs_to :organization
  
  validates_presence_of :key, :organization_id
  validates_uniqueness_of :key, scope: :organization_id, case_sensitive: false
end
