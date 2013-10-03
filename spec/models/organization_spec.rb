require 'spec_helper'

describe Organization do
  
  describe '#validate' do
    after :all do
      it { should_not be_valid }
    end
    
    describe 'subdomain' do
      subject(:organization) { build(:organization, subdomain: subdomain) }
      
      context 'unique' do
        let(:subdomain) { create(:organization).subdomain }
      end
      
      context 'no spaces' do
        let(:subdomain) { 'has space' }
      end
      
      context 'lower case' do
        let(:subdomain) { 'camelCase' }
      end
      
      context 'doesnt start with dash' do
        let(:subdomain) { '-dash-start' }
      end
      
      context 'doesnt end with dash' do
        let(:subdomain) { 'end-dash-' }
      end
      
      context 'not empty' do
        let(:subdomain) { '' }
      end
    end
        
  end
end
