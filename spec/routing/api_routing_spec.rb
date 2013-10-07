require 'spec_helper'

describe 'api routes' do
  let(:organization) { create(:organization) }
  let(:base_url) { "http://#{organization.subdomain}.domain.test" }
  
  describe 'GET /roles' do
    subject { { get: base_url + '/roles' }  }
    it { should route_to(controller: 'roles', action: 'index') }
  end
  
  describe 'POST /roles' do
    subject { { post: base_url + '/roles' } }
    it { should route_to(controller: 'roles', action: 'create') }
  end
  
  describe 'DELETE /roles/:email' do
    subject { { delete: base_url + '/roles/test-email@mail.university.edu' } }
    it { should route_to(controller: 'roles', action: 'destroy', id: 'test-email@mail.university.edu') }
  end
  
end