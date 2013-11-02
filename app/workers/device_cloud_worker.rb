class DeviceCloudWorker
  @queue = :displays
  
  # Message Protocol:
  #   U = upper
  #   M = middle
  #   L = lower
  # Format:
  #   1 - 3 updates for U, M, L, space padded, with units
  #   example: `U 5";M10";L 3";`
  #   space padded numbers followed by unit.
  def self.perform(display, message = "U   ;M   ;L   ;")
    device_cloud.send_message display['gateway_id'], display['mac_address'], message
  end
  
  def self.device_cloud
    @device_cloud_client ||= DeviceCloud::Client.new
  end
  
end
