namespace :displays do
  
  desc 'update all displays with device cloud'
  task :update => :environment do
    Organization.select(:id).each do |organization_id|
      Resque.enqueue DisplayWorker, organization_id
    end
  end
  
end