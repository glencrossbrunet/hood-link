require 'spec_helper'

describe Role do
  
  describe '#validate' do
    subject { build(:role, name: name) }
    
    describe 'valid name' do
      after :each do
        it { should be_valid }
      end
      
      context 'god' do
        let(:name) { 'god' }
      end
      
      context 'admin' do
        let(:name) { 'admin' }
      end
      
      context 'member' do
        let(:name) { 'member' }
      end
    end
    
    describe 'invalid name' do
      let(:name) { 'anything' }
      it { should_not be_valid }
    end
  end
  
end