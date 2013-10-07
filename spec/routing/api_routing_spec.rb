require 'spec_helper'

describe 'api routes' do
  let(:organization) { create(:organization) }
  let(:base_url) { "http://#{organization.subdomain}.domain.test" }
  subject { { get: base_url + path } }
  
  describe 'GET /roles' do
    let(:path) { '/roles' }
    it { should route_to(controller: 'roles', action: 'index') }
  end
  
end