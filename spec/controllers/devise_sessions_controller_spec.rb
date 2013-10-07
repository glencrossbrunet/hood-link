require 'spec_helper'

describe Devise::SessionsController do

  describe 'after sign in' do
    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
      post(:create, user: { email: user.email, password: 'verysecret' })
    end
    let(:user) { create(:user) }
    subject { response }
    it { should redirect_to(organizations_path) }
  end
  
  describe 'after sign out' do
    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.host = 'organization.example.com'
      sign_in :user, create(:user)
    end
    subject { delete(:destroy); response }
    it { should redirect_to('http://www.example.com/') }
  end

end