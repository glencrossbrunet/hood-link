# == Schema Information
#
# Table name: lines
#
#  id              :integer          not null, primary key
#  filters         :json
#  visible         :boolean
#  user_id         :integer
#  organization_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Line < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  
  def as_json(options = {})
    attributes.slice(*%w(id filters visible updated_at))
  end
end
