require 'spec_helper'

describe DisplayWorker do  
  let(:fume_hood) { create(:fume_hood) }
  
  describe '#height' do
    context 'empty number -> NA' do
      subject { DisplayWorker.height(nil) }
      it { should eq('NA ') }
    end
    
    context 'float % -> height inches' do
      subject { DisplayWorker.height(70.0) }
      it { should eq('28"') }
    end
  end
  
  describe '#message_for' do    
    context 'no samples' do
      let(:sample_metric) { create(:sample_metric) }
      subject { DisplayWorker.message_for(fume_hood, sample_metric.id, nil) }
      it { should eq('UNA ;MNA ;LNA ;') }
    end
    
    context 'no aggregate' do
      let(:sample) { create(:sample, fume_hood: fume_hood) }
      subject { DisplayWorker.message_for(fume_hood, sample.sample_metric.id, nil) }
      it { should_not eq("UNA ;MNA ;LNA ;") }
    end
  end
  
  describe '#best_for' do
    let(:organization) { fume_hood.organization }
    
    context 'no samples' do
      let(:sample_metric) { create(:sample_metric) }
      subject { DisplayWorker.best_for(organization, sample_metric.id) }
      it { should be_nil }
    end
    
    context 'sparse samples' do
      let(:sample_metric) { create(:sample_metric) }
      before { fume_hood.update_attribute(:aggregates, { sample_metric.id.to_s => 20.0 }) }
      before { create(:fume_hood, organization: organization) }
      subject { DisplayWorker.best_for(organization, sample_metric.id) }
      it { should be_within(0.0001).of(20.0) }
    end
  end
  
  describe '#perform' do
    let(:organization) { fume_hood.organization }
    
    it 'should not throw errors' do
      expect{ DisplayWorker.perform(organization.id) }.not_to raise_error
    end
  end
end