describe FiltersController do
  include_context 'admin of organization'
  
  describe '#index' do
    before { organization.filters.create([ { key: 'building' }, { key: 'room' } ]) }
    before { get :index, format: :json }
    
    let(:json) { MultiJson.load(response.body, symbolize_keys: true) }
    it 'should have the keys' do
      keys = json.collect { |h| h[:key] }.sort
      expect(keys).to eq(%w(building room))
    end
  end
  
  describe '#create' do
    before { post :create, format: :json, key: 'metadata' }
    
    context 'response' do
      subject { response }
      it { should be_successful }
    end
    
    specify 'filter with key created' do
      expect(organization.filters.first.key).to eq('metadata')
    end
  end
end