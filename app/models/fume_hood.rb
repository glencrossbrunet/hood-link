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
	
	def data
		{ display_id: '00000000-00000000-00409DFF-FF457D17 | 00:13:a2:00:40:a8:b8:9b!' }
	end
	
	def metadata
		keys = organization.filters.map(&:key)
		data = {}
		keys.each do |key|
			data[key] = ''
		end
		data
	end

end
