require 'spec_helper'

describe 'subdomain routes' do
  let(:url) { "http://#{subdomain}.domain.com/" }
  subject { { get: url } }
  
  context 'www' do
    let(:subdomain) { 'www' }
    it { should route_to(controller: 'static', action: 'welcome') }
  end
  
  context 'organization' do
    let(:subdomain) { create(:organization).subdomain }
    it { should route_to(controller: 'organizations', action: 'dashboard') }
  end
end