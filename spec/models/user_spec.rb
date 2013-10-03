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
end
