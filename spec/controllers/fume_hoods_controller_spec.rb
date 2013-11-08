require 'spec_helper'

describe FumeHoodsController do
  include_context 'admin of organization'
  
  describe '#index' do
    before do
      2.times { organization.fume_hoods.create(attributes_for(:fume_hood)) }
      get :index, format: :json
    end
    specify 'fume hoods returned' do
      json = MultiJson.load(response.body)
      expect(json.length).to eq(2)
    end
  end
	
	describe '#display' do
		let(:fume_hood) { create(:fume_hood) }
		subject { get :display, format: :json }
		it { should be_successful }
	end
  
end