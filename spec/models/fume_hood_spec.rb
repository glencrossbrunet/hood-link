# == Schema Information
#
# Table name: fume_hoods
#
#  id              :integer          not null, primary key
#  organization_id :integer          not null
#  external_id     :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
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
  
end
