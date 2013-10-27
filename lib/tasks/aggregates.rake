namespace :aggregates do
  
  desc 'cache monthly avg for percent open for each fume hood'
  task :percent_open => :environment do
    metric = SampleMetric.where(name: 'Percent Open').first
    FumeHood.select(:id).each do |id|
      Resque.enqueue AggregateWorker, id, metric.id
    end
  end
  
end
