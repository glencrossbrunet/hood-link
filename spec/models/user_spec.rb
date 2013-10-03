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
  describe '::create' do
    subject { create(:user) }
    it { should be_valid }
  end
  
  describe '::parse' do
    context 'new email' do
      subject { User.parse(generate(:email)) }
      it { should be_persisted }
    end
    
    context 'user already exists' do
      let(:user) { create(:user) }
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
    #  end
    # end
  end
  
  describe '#roles' do
    subject(:user) { create(:user) }
    let(:organization) { create(:organization) }
    
    specify 'users can be admins' do
      user.add_role :admin, organization
      expect(user.has_role? :admin, organization).to be_true
    end
    
    specify 'users can be members' do
      user.add_role :member, organization
      expect(user.has_role? :member, organization).to be_true
      expect(user.has_role? :admin, organization).not_to be_true
    end
  end
end
