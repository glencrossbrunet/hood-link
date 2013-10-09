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
  
end