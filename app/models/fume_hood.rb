class FumeHood < ActiveRecord::Base
  belongs_to :organization
  
  validates_presence_of :external_id, :organization_id
  validates_uniqueness_of :external_id
end
