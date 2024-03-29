# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  subdomain  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  token      :string(255)
#

describe Organization do
  
  describe '#validate' do
    describe 'name' do
      subject { build(:organization, name: '') }
      it { should_not be_valid }
    end
    
    describe 'subdomain' do
      subject(:organization) { build(:organization, subdomain: subdomain) }
      
      context 'unique' do
        let(:subdomain) { create(:organization).subdomain }
        it { should_not be_valid }
      end
      
      context 'no spaces' do
        let(:subdomain) { 'has space' }
        it { should_not be_valid }
      end
      
      context 'lower case' do
        let(:subdomain) { 'camelCase' }
        it { should_not be_valid }
      end
      
      context 'doesnt start with dash' do
        let(:subdomain) { '-dash-start' }
        it { should_not be_valid }
      end
      
      context 'doesnt end with dash' do
        let(:subdomain) { 'end-dash-' }
        it { should_not be_valid }
      end
      
      context 'not empty' do
        let(:subdomain) { '' }
        it { should_not be_valid }
      end
    end
  end
  
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  
  describe '#members' do
    let(:members) { organization.members }
    
    before { user.add_role(:member, organization) }
    
    context 'collection of members' do
      before { create(:user).add_role(:member, organization) }
      subject { members.count }
      it { should eq(2) }
    end
    
    context 'relate to users' do
      subject { members.first }
      it { should eq(user) }
    end
  end
  
  describe '#admins' do
    before { user.add_role(:admin, organization) }
    
    context 'collection of admins' do
      before { create(:user).add_role(:member, organization) }
      subject { organization.admins.count }
      it { should eq(1) }
    end
  end
  
  describe '#samples' do
    it { should respond_to(:samples) }
  end
  
  describe '#daily_intervals' do
    before { create(:fume_hood, organization: organization) }
    let(:day) { Date.parse('Aug 10, 2011') }
    let(:intervals) { organization.daily_intervals(day, 1.hour) }
    let(:external_ids) { organization.fume_hoods.pluck(:external_id) }
    
    describe 'all hoods' do
      subject { intervals }
      its(:keys) { should eq(external_ids) }
    end
    
    describe 'hourly data' do
      subject { intervals[external_ids.first] }
      its(:length) { should eq(24) } 
    end
  end

  describe '#daily_intervals_cache_key' do
    let(:id) { organization.id }
    let(:day) { Date.parse('Aug 10, 2011') }
    subject { organization.daily_intervals_cache_key(day, 60.seconds) }
    it { should eq("organizations:#{id}:20110810:60") }
  end
end
