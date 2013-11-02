describe DeviceCloudWorker do
  
  describe '::device_cloud' do
    subject { DeviceCloudWorker.device_cloud }
    it { should_not be_nil }
  end
  
end