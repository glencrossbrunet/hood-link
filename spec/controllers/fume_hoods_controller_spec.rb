describe FumeHoodsController do
  include_context 'admin of organization'
  
  describe '#index' do
    before do
      create(:fume_hood, organization: organization, external_id: 'b-1')
      create(:fume_hood, organization: organization, external_id: 'a-11')
      create(:fume_hood, organization: organization, external_id: 'a-9')
      get :index, format: :json
    end
    
    describe 'all hoods' do
      subject { json }
      its(:length) { should eq(3) }
    end
    
    describe 'ordered by id' do
      subject { json[0]['external_id'] }
      it { should eq('a-9') }
    end
  end
	
	describe '#display' do
		let(:fume_hood) { create(:fume_hood, organization: organization) }
		subject { get :display, format: :json, id: fume_hood.id }
		it { should be_successful }
	end
  
  describe '#upload' do
    let(:csv) do
      <<-CSV.gsub(/\ +/, ' ')
      external_id,bac_number,building_num,building_name
      pulppaper-203-2,260302,158,"Pulp & Paper"
      pulppaper-203-3,260303,158,"Pulp & Paper"
      CSV
    end
    
    before { post :upload, csv: csv, format: :json }
    
    it 'should create and upload new fume hoods' do
      fh = FumeHood.find_by(external_id: 'pulppaper-203-2')
      expect(fh.data['building_name']).to eq('Pulp & Paper')
    end
  end
  
  describe '#samples' do
    before do
      2.times do
         create(:fume_hood, organization: organization)
      end
    end
    
    let(:fume_hoods) { organization.fume_hoods }

    before { get :samples, format: :json }
    
    describe 'default 2 weeks by hour' do
      subject { json[fume_hoods.first.external_id] }
      its(:length) { should eq(14 * 24) } 
    end
  end
end