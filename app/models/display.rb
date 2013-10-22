# == Schema Information
#
# Table name: displays
#
#  id         :integer          not null, primary key
#  server_id  :string(255)
#  device_id  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Display < ActiveRecord::Base
end
