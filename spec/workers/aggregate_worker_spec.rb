require 'spec_helper'

describe AggregateWorker do
  let(:fume_hood) { create(:fume_hood) }
  let(:metric) { create(:sample_metric) }
  before { fume_hood.samples.create(sample_metric: metric, value: 3.0, sampled_at: 2.weeks.ago) }
  before { AggregateWorker.perform(fume_hood.id, metric.id) }
  
  describe 'aggregate metric' do
    subject { fume_hood.reload.aggregates[metric.id.to_s] }
    it { should be_within(0.001).of(3.0) }
  end
end