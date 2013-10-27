# == Schema Information
#
# Table name: samples
#
#  id               :integer          not null, primary key
#  fume_hood_id     :integer          not null
#  sample_metric_id :integer          not null
#  unit             :string(255)
#  value            :float            not null
#  source           :string(255)
#  sampled_at       :datetime         not null
#  created_at       :datetime
#  updated_at       :datetime
#

describe Sample do  
  describe '#validate' do
    let(:sample) { build(:sample) }
    subject { sample }
    
    it { should be_valid }
    
    describe 'fume_hood required' do
      before { sample.fume_hood = nil }
      it { should_not be_valid }
    end
    
    describe 'sample_metric required' do
      before { sample.sample_metric = nil }
      it { should_not be_valid }
    end
    
    describe 'value required' do
      before { sample.value = nil }
      it { should_not be_valid }
    end
    
    describe 'sampled_at required' do
      before { sample.sampled_at = nil }
      it { should_not be_valid }
    end
  end
  
  describe '#avg' do
    let(:sample_metric) { create(:sample_metric) }
    let(:fume_hood) { create(:fume_hood) }
    let(:defaults) do
      { sample_metric_id: sample_metric.id, 
        fume_hood_id: fume_hood.id }
    end
    
    let(:start) { DateTime.parse('2013-01-01 05:00:00') }
    
    before :each do
      Sample.create defaults.merge(sampled_at: start, value: 1.0)
      Sample.create defaults.merge(sampled_at: start + 2.hours, value: 2.0)
    end
        
    describe '1 hour in' do
      let(:offset) { 1.hour }
      subject { fume_hood.samples.avg(sample_metric, start .. (start + offset)) }
      it { should be_within(0.001).of(1.0) }
    end
    
    describe '2 hours in' do
      let(:offset) { 2.hours }
      subject { fume_hood.samples.avg(sample_metric, start .. (start + offset)) }
      it { should be_within(0.001).of(1.0) }
    end
    
    describe '3 hours in' do
      let(:offset) { 3.hours }
      subject { fume_hood.samples.avg(sample_metric, start .. (start + offset)) }
      it { should be_within(0.001).of((2 * 1.0 + 1 * 2.0) / 3) }
    end
    
    describe '4 hours in' do
      let(:offset) { 4.hours }
      subject { fume_hood.samples.avg(sample_metric, start .. (start + offset)) }
      it { should be_within(0.001).of((2 * 1.0 + 2 * 2.0) / 4) }
    end
  end
  
end