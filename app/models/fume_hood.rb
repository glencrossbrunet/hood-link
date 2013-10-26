# == Schema Information
#
# Table name: fume_hoods
#
#  id              :integer          not null, primary key
#  organization_id :integer          not null
#  external_id     :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class FumeHood < ActiveRecord::Base
  belongs_to :organization
  
  validates_presence_of :external_id, :organization_id
  validates_uniqueness_of :external_id
	
	has_many :samples
	
	def metadata
		keys = organization.filters.map(&:key)
		data = {}
		keys.each do |key|
			data[key] = ''
		end
		data
	end
  
  # sash heights: 39.4" * (pct open)
  # 
  # need
  # - most recent sash height
  # - moving avg of all of them
  # - best (lowest) avg

end
