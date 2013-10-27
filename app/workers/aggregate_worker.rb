# aggregates fume hood samples for the last month for a sample metric
# saves the aggregate in the aggregates json of the fume hood

class AggregateWorker
  @queue = :aggregates
  
  def self.perform(fume_hood_id, metric_id)
    fume_hood = FumeHood.find(fume_hood_id)
    samples = fume_hood.samples.where(sample_metric_id: metric_id)
    avg = samples.avg(1.month.ago .. 1.minute.ago)
    aggregates = fume_hood.aggregates.merge(metric_id.to_s => avg)
    fume_hood.update_attributes aggregates: aggregates
  end
end