class FumeHood < ActiveRecord::Base
  belongs_to :organization
  
  validates_presence_of :external_id, :organization_id
  validates_uniqueness_of :external_id
	
	def metadata
		keys = organization.filters.map(&:key)
		data = {}
		keys.each do |key|
			data[key] = ''
		end
		data
	end

end
