# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  resource_id   :integer
#  resource_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Role do
  
  describe '#validate' do
    subject { build(:role, name: name) }
    
    describe 'valid name' do
      context 'admin' do
        let(:name) { 'admin' }
        it { should be_valid }
      end
      
      context 'member' do
        let(:name) { 'member' }
        it { should be_valid }
      end
    end
    
    describe 'invalid name' do
      let(:name) { 'anything' }
      it { should_not be_valid }
    end
  end
  
end
