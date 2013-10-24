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
  
end