# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  subdomain  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

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
  
end
