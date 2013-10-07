require 'spec_helper'

describe RolesController do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  before { request.host = "#{organization.subdomain}.example.com" }
  before { sign_in :user, user }
  before { user.add_role(:admin, organization) }
  
  describe '#index' do
    
    let(:members) do
      2.times.map { create(:user) }
    end
    
    before do
      members.each { |member| member.add_role(:member, organization) }
    end
        
    it 'should output correct json' do
      get :index, format: :json
      json = [
        { email: members.first.email, type: 'member' },
        { email: members.last.email, type: 'member' },
        { email: user.email, type: 'admin' }
      ]
      expect(response.body).to eq(json.to_json)
    end
  end
  
  describe '#destroy' do
    let(:member) { create(:user) }
    before { member.add_role(:member, organization) }
    before { delete :destroy, format: :json, id: member.email }
    
    context 'member no longer a member' do
      subject { member }
      it { should_not have_role(:member, organization) }
    end
    
    context 'retuns successful' do
      subject { response }
      it { should be_successful } 
    end
  end
  
end