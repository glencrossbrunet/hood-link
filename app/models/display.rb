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
  @queue = :displays
  
  def update_screen(message)
    Resque.enqueue self.class, self.id, message
  end
  
  # Message Protocol:
  #   U = upper
  #   M = middle
  #   L = lower
  # Format:
  #   1 - 3 updates for U, M, L, space padded, with units
  #   example: `U 5";M10";L 3";`
  #   space padded numbers followed by unit.
  def self.perform(id, message = "U   ;M   ;L   ;")
    display = find(id)
    device_cloud.send_message display.server_id, display.device_id, message
  end
  
  def self.device_cloud
    @device_cloud_client ||= DeviceCloud::Client.new
  end
end