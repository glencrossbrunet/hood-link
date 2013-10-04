require 'spec_helper'

describe OrganizationsController do
  
  describe '#dashboard' do
    let(:organization) { create(:organization) }
    before(:each) do
      request.host = "#{organization.subdomain}.example.com"
    end
    subject { get :dashboard; response }
    
    context 'visitor' do
      it { should redirect_to(new_user_session_path) }
    end
    
    context 'user' do
      let(:user) { create(:user) }
      before :each do
        sign_in :user, user
      end
      
      context 'not member' do
        it { should redirect_to(new_user_session_path) }
      end
      
      context 'member of wrong organization' do
        before { user.add_role(:member, create(:organization)) }
        it { should redirect_to(new_user_session_path) }
      end
      
      context 'member' do
        before { user.add_role(:member, organization) }
        it { should be_successful }
      end
      
      context 'admin of wrong organization' do
        before { user.add_role(:admin, create(:organization)) }
        it { should redirect_to(new_user_session_path) }
      end
      
      context 'admin' do
        before { user.add_role(:admin, organization) }
        it { should be_successful }
      end
    end
  end
  
  
  describe '#index' do
    let(:user) { create(:user) }
    subject { get :index; response }
    
    context 'visitor' do
      it { should redirect_to(new_user_session_path) }
    end
    
    context 'user' do
      before { sign_in user }
      it { should redirect_to(root_path) }
      
      context 'member' do
        let(:organization) { create(:organization) }
        before do
          request.host = 'www.example.com'
          user.add_role(:member, organization)
        end
        it { should redirect_to("http://#{organization.subdomain}.example.com/")  }
      end
      
      context 'super admin' do
        before { user.add_role(:admin) }
        before { create(:organization); create(:organization) }
        it { should be_successful }
      end
    end
  end
  
end