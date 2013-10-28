class DisplayWorker
  @queue = :displays
  
  def self.perform(organization_id)
    metric = SampleMetric.find_by(name: 'Percent Open')
    organization = Organization.find(organization_id)    
    best = organization.fume_hoods.map { |fh| fh.aggregates[metric.id.to_s] }.min
    organization.fume_hoods.each do |fume_hood|
      update_display_for(fume_hood, metric.id, best) if fume_hood.display.present?
    end
  end  
  
  # sash heights: 39.4" * (pct open)
  # 
  # need
  # - most recent sash height
  # - moving avg of all of them
  # - best (lowest) avg
  def self.update_display_for(fume_hood, metric_id, best)
    value = fume_hood.samples.where(sample_metric_id: metric_id).most_recent.try(:value)
    aggregate = fume_hood.aggregates[metric_id.to_s]
    message = %Q(U#{height(value)};M#{height(aggregate)};L#{height(best)};)
    fume_hood.display.update_screen(message)
  end
  
  def self.height(percent_open)
    if percent_open.present?
      height = (percent_open * 0.394).round
      '%2d"' % height
    else
      'NA '
    end
  end
end