# == Schema Information
#
# Table name: filters
#
#  id              :integer          not null, primary key
#  key             :string(255)      not null
#  organization_id :integer          not null
#  created_at      :datetime
#  updated_at      :datetime
#

describe Filter do
    
  describe '#validate' do
    let(:filter) { build(:filter) }
    subject { filter }
    
    context 'organization_id required' do
      before { filter.organization = nil }
      it { should_not be_valid }
    end
    
    context 'key required' do
      before { filter.key = nil }
      it { should_not be_valid }
    end
    
    context 'key unique' do
      before { filter.dup.save }
      it { should_not be_valid }
      
      context 'within organization' do
        before { filter.organization = create(:organization) }
        it { should be_valid }
      end
    end
  end
  
end
