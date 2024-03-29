class DisplayWorker
  @queue = :displays
  
  def self.perform(organization_id)
    metric_id = SampleMetric.where(name: 'Percent Open').first_or_create.id
    organization = Organization.find(organization_id)
    
    best = random_best # best_for(organization, metric_id)
    
    organization.fume_hoods.each do |fume_hood|
      update_display_for(fume_hood, metric_id, best) if fume_hood.display.present?
    end
  end
  
  def self.best_for(organization, metric_id)
    aggregates = organization.fume_hoods.map do |fume_hood|
      fume_hood.aggregates[metric_id.to_s]
    end
    aggregates.compact.reject(&:zero?).min
  end
  
  # sash heights: 39.4" * (pct open)
  # 
  # need
  # - moving hourly avg sash height
  # - moving monthly avg of sash height
  # - best (lowest) avg
  def self.update_display_for(fume_hood, metric_id, best)
    Resque.enqueue DeviceCloudWorker, fume_hood.display, message_for(fume_hood, metric_id, best)
  end
  
  def self.message_for(fume_hood, metric_id, best)
    value = fume_hood.samples.where(sample_metric_id: metric_id).avg(1.hour.ago .. DateTime.now)
    aggregate = fume_hood.aggregates[metric_id.to_s]
    %Q(U#{height(value)};M#{height(aggregate)};L#{height(best)};)
  end
  
  def self.height(percent_open)
    if percent_open.present?
      height = (percent_open * 0.394).round
      '%2d"' % height
    else
      'NA '
    end
  end
	
	def self.random_best
		(4..6).step(0.1).to_a.sample
	end
end