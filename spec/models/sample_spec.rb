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
    
    subject { fume_hood.samples.avg(start .. (start + offset)) }
        
    describe '1 hour in' do
      let(:offset) { 1.hour }
      it { should be_within(0.001).of(1.0) }
    end
    
    describe '2 hours in' do
      let(:offset) { 2.hours }
      it { should be_within(0.001).of(1.0) }
    end
    
    describe '3 hours in' do
      let(:offset) { 3.hours }
      it { should be_within(0.001).of((2 * 1.0 + 1 * 2.0) / 3) }
    end
    
    describe '4 hours in' do
      let(:offset) { 4.hours }
      it { should be_within(0.001).of((2 * 1.0 + 2 * 2.0) / 4) }
    end
  end
  
  describe 'scopes' do
    before { Sample.delete_all }
    
    describe '#percent open' do
      before { 2.times { create(:pct_sample) } }
      subject { Sample.percent_open }
      its(:count) { should eq(2) }
    end
    
    describe '#flow rate' do
      before { 2.times { create(:flow_sample) } }
      subject { Sample.flow_rate }
      its(:count) { should eq(2) }
    end    
  end
  
  describe '::daily_intervals' do
    let(:datetime) { DateTime.parse('Aug 10, 2011 00:00') }
    
    let(:samples) do
      models = 4.times.map do |i|
        create(:pct_sample, value: i, sampled_at: datetime.advance(hours: i * 6))
      end
      Sample.where(id: models.map(&:id))
    end
    
    subject { samples.daily_intervals(datetime, 2.hours) }
    
    its(:length) { should eq(12) }
    
    it 'should have correct keys' do
      expect(subject.first.keys.sort).to eq(%w(sampled_at unit value))
    end
    
    it 'should have correct values' do
      expect(subject.map{ |h| h[:value].to_i }).to eq((0..3).to_a.cycle(3).sort)
    end
  end
end