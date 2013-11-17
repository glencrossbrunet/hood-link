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

require 'spec_helper'

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
  
  describe 'data json store' do
    let(:fume_hood) { create(:fume_hood) }
    
    describe 'defaults to hash' do
      subject { fume_hood.data }
      it { should eq({}) }
    end
    
    specify 'add data' do
      fume_hood.data = { 'building' => 'McTavish' }
      expect(fume_hood.data['building']).to eq('McTavish')
    end
  end
  
  describe '#display from mac_address and gateway_id' do
    let(:fume_hood) { create(:fume_hood) }
    before { fume_hood.update_attribute :data, 'mac_address' => 'abcde', 'gateway_id' => '12345' }
    subject { fume_hood.display }
    it { should eq('mac_address' => 'abcde', 'gateway_id' => '12345') }
  end
  
  describe '#periodic_samples' do
    let(:fume_hood) { create(:fume_hood) }
    before do
      fume_hood.samples.create([
        { sample_metric_id: 1, sampled_at: DateTime.parse('Jan 3, 2013 02:00'), value: 20 },
        { sample_metric_id: 1, sampled_at: DateTime.parse('Jan 3, 2013 02:15'), value: 30 }
      ])
    end
    
    let(:expected) do
      [
        { sampled_at: DateTime.parse('Jan 3, 2013 01:00'), value: nil },
        { sampled_at: DateTime.parse('Jan 3, 2013 01:30'), value: nil },
        { sampled_at: DateTime.parse('Jan 3, 2013 02:00'), value: 20.0 },
        { sampled_at: DateTime.parse('Jan 3, 2013 02:30'), value: 30.0 },
        { sampled_at: DateTime.parse('Jan 3, 2013 03:00'), value: 30.0 }
      ]
    end
    
    let(:period) do
      DateTime.parse('Jan 3, 2013 01:00')..DateTime.parse('Jan 3, 2013 03:00')
    end
    
    subject { fume_hood.periodic_samples(30.minutes, sampled_at: period) }
    it { should be_matching(expected) }
  end

  describe '::periodic_samples' do
    let(:first) { create(:fume_hood) }
    let(:second) { create(:fume_hood) }
    
    let(:fume_hoods) do
      FumeHood.where(id: [ first, second ].map(&:id))
    end
    
    before do
      first.samples.create([
        { sample_metric_id: 1, sampled_at: DateTime.parse('Jan 3, 2013 03:00'), value: 20 },
        { sample_metric_id: 1, sampled_at: DateTime.parse('Jan 3, 2013 04:00'), value: 30 }
      ])
      second.samples.create({ sample_metric_id: 1, sampled_at: DateTime.parse('Jan 3, 2013 03:15'), value: 15 })
    end
    
    let(:expected) do
      [
        [ DateTime.parse('Jan 3, 2013 02:30'), nil, nil ],
        [ DateTime.parse('Jan 3, 2013 03:00'), 20.0, nil ],
        [ DateTime.parse('Jan 3, 2013 03:30'), 20.0, 15.0 ],
        [ DateTime.parse('Jan 3, 2013 04:00'), 30.0, 15.0 ]
      ].map{ |values| Hash[ [:sampled_at, first.external_id, second.external_id].zip(values) ] }
    end
    
    specify 'samples ready to be csv' do
      period = DateTime.parse('Jan 3, 2013 02:30')..DateTime.parse('Jan 3, 2013 04:00')
      interval = 30.minutes
      conditions = { sample_metric_id: 1, sampled_at: period }
      output = fume_hoods.periodic_samples(interval, conditions)
      expect(output).to be_matching(expected)
    end
    
  end

=begin
  describe '#periodic_samples' do
    
    
    before do
      
    end
    
    
    
    
    before { fume_hoods.first.samples.create([]) }
  end
=end
  
end
