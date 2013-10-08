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
  
  describe 'GET /filters' do
    subject { { get: base_url + '/filters' } }
    it { should route_to(controller: 'filters', action: 'index') }
  end
  
  describe 'POST /filters' do
    subject { { post: base_url + '/filters' } }
    it { should route_to(controller: 'filters', action: 'create') }
  end
  
  describe 'PUT /filters/:id' do
    subject { { patch: base_url + '/filters/24' } }
    it { should route_to(controller: 'filters', action: 'update', id: '24') }
  end
  
  describe 'DELETE /filers/:id' do
    subject { { delete: base_url + '/filters/24' } }
    it { should route_to(controller: 'filters', action: 'destroy', id: '24') }
  end
  
end