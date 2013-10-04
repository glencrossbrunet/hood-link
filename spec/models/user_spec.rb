# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'

describe User do
  let(:organization) { create(:organization) }
  let(:user) { create(:user) }
  
  
  describe '::create' do
    subject { user }
    it { should be_valid }
  end
  
  describe '::parse' do
    context 'new email' do
      subject { User.parse(generate(:email)) }
      it { should be_persisted }
    end
    
    context 'user already exists' do
      it 'finds the user' do
        expect(User.parse(user.email)).to eq(user)
      end
    end
    
    # context 'email and name' do
    #   let(:email) { generate(:email) }
    #   subject(:user) { User.parse("Test User <#{email}>") }
    #   it { should be_persisted }
    #   it 'has the correct email' do
    #     expect(user.email).to == email
    #   end
    # end
  end
  
  describe '#roles' do    
    describe 'god' do
      subject { create(:god) }
      it { should have_role(:admin, organization) }
    end
    
    describe 'admin' do
      subject { create(:admin, organization: organization) }
      it { should have_role(:admin, organization) }
      it { should_not have_role(:admin) }
    end
  end
  
  describe '#organizations' do
    subject { user.organizations.to_a }
    
    context 'no membership' do
      it { should be_empty }
    end
    
    context 'membership' do
      before { user.add_role(:member, organization) }
      it { should eq([organization]) }
    end
  end
end
