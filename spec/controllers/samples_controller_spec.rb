describe SamplesController do
  let(:organization) { create(:organization, token: 'secret') }
  let(:fume_hood) { create(:fume_hood, organization: organization) }
  let(:sample_metric) { create(:sample_metric) }
  before { request.host = "#{organization.subdomain}.example.com" }
  
  describe '#create' do
    describe 'bad token' do
      subject { post :create, organization: { token: 'incorrect' } }
      it { should be_forbidden }
    end
    
    let(:json) do
      {
        organization: {
          token: 'secret'
        },
        fume_hood: {
          external_id: fume_hood.external_id
        },
        sample_metric: {
          name: sample_metric.name
        },
        sample: {
          value: 12.5,
          sampled_at: 2.minutes.ago
        }
      }
    end
    
    specify 'sample gets created' do
      expect{ post :create, json }.to change{ Sample.count }.by(1)
    end
    
    describe 'identical samples' do
      before { post :create, json }
      specify 'only one created' do
        expect{ post :create, json }.not_to change{ Sample.count }
      end
    end
    
    describe 'similar values' do
      before { post :create, json }
      specify 'no new sample' do
        new_json = json.merge(sample: { value: 12.500000001, sampled_at: 1.hour.ago })
        expect{ post :create, new_json }.not_to change{ Sample.count }
      end
    end
    
    specify 'new fume hoods get created' do
      new_json = json.merge(fume_hood: { external_id: 'testing' })
      expect{ post :create, new_json }.to change{ FumeHood.count }.by(1)
    end
  end
end