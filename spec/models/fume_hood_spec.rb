# == Schema Information
#
# Table name: fume_hoods
#
#  id              :integer          not null, primary key
#  organization_id :integer          not null
#  external_id     :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#  data            :json             default({})
#

describe FumeHood do
  
  describe '#validate' do
    let(:fume_hood) { build(:fume_hood) }
    subject { fume_hood }
    
    context 'external_id unique' do
      before { fume_hood.dup.save }
      it { should_not be_valid }
    end
    
    context 'external_id present' do
      before { fume_hood[:external_id] = nil }
      it { should_not be_valid }
    end
    
    context 'organization_id present' do
      before { fume_hood[:organization_id] = nil }
      it { should_not be_valid }
    end
  end
  
  let(:fume_hood) { create(:fume_hood) }
  
  describe '#data' do
    describe 'defaults to hash' do
      subject { fume_hood.data }
      it { should eq({}) }
    end
    
    specify 'merges data' do
      fume_hood.data = { 'building' => 'McTavish' }
      expect(fume_hood.data['building']).to eq('McTavish')
    end
  end
  
  describe '#display' do
    subject { fume_hood.display }
    
    describe 'no mac_address' do
      before { fume_hood.update_attribute :data, 'gateway_id' => '12345' }
      it { should be_nil }
    end
    
    describe 'no gateway_id' do
      before { fume_hood.update_attribute :data, 'mac_address' => '12345' }
      it { should be_nil }
    end
    
    describe 'mac_address and gateway_id' do
      let(:display) { { 'mac_address' => 'abcde', 'gateway_id' => '12345' } }
      before { fume_hood.update_attribute :data, display }
      it { should eq(display) }
    end
  end
  
  describe '::intervals' do
    let(:fume_hoods) do
      hoods = 2.times.map { create(:fume_hood) }
      FumeHood.where(id: hoods.map(&:id))
    end
    
    let(:range) { Date.parse('Aug 10, 2011')..Date.parse('Aug 14, 2011') }
    let(:intervals) { fume_hoods.intervals(range, 1.hour) }
    
    it 'should have each hood' do
      expect(intervals.keys).to eq(fume_hoods.map(&:external_id))
    end
    
    it 'should be intervals' do
      hood = fume_hoods.first
      expect(intervals[hood.external_id]).to eq(hood.intervals(range, 1.hour))
    end
  end
  
  describe '#intervals' do
    let(:range) { Date.parse('Aug 10, 2011')..Date.parse('Aug 14, 2011') }
    let(:intervals) { fume_hood.intervals(range, 1.hour) }
    
    it 'should be over a 5 day period' do
      expect(intervals.length).to eq(24 * 5)
    end
  end
  
  describe '#daily_intervals' do
    let(:day) { Date.parse('Jan 5, 2005') }
    before { create(:pct_sample, fume_hood: fume_hood, sampled_at: day.advance(hours: -1)) }
    let(:intervals) { fume_hood.daily_intervals(day, 1.hour) }
    
    it 'should be over a 24 hour period' do
      expect(intervals.length).to eq(24)
    end
    
    it 'should have 3 fields' do
      expect(intervals.first.keys).to eq(%w(sampled_at value unit))
    end
  end
  
  describe '#cache_key' do
    let(:fume_hood) { create(:fume_hood) }
    subject { fume_hood.cache_key(Date.parse('Feb 16, 2001'), 1.hour) }
    it { should eq("fh#{fume_hood.id}_20010216_3600") }
  end
end
