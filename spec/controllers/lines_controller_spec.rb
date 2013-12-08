describe LinesController do
  include_context 'admin of organization'
  
  describe '#index' do
    before { create(:line, user: user, organization: organization) }
    before { get :index, format: :json }
    
    describe 'all lines' do
      subject { json }
      its(:length) { should eq(1) }
    end
    
    describe 'correct keys' do
      subject { json[0] }
      its(:keys) { should eq(%w(id filters name visible updated_at)) } 
    end
  end
  
  describe '#create' do
    let(:filter) { organization.filters.create(key: 'json') }
    let(:attrs) { attributes_for(:line, user: user, organization: organization) }
    before { attrs[:filters].merge!(filter.key => true) }
    before { post :create, attrs.merge(format: :json) }
    
    context 'response' do
      subject { response }
      it { should be_successful }
    end
    
    describe 'line created' do
      subject { user.lines.first }
      it { should_not be_nil }
    end
    
    describe 'filters' do
      subject { json['filters'] }
      it { should eq(attrs[:filters]) }
    end
  end
  
  describe '#update' do
    let(:line) { create(:line, user: user, organization: organization) }
    before { put :update, format: :json, visible: true, id: line.id }
    
    context 'response' do
      subject { response }
      it { should be_successful }
    end
    
    describe 'line updated' do
      subject { line.reload }
      its(:visible) { should eq(true) }
    end
  end
end