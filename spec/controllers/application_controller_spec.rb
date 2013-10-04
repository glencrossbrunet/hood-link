require 'spec_helper'

describe ApplicationController do
  before { request.host = 'www.example.com' }
  
  describe '#url_for' do
    it 'should allow subdomain option' do
      expect(root_url(subdomain: 'organization')).to eq('http://organization.example.com/')
    end
    
    specify 'no subdomain ok too' do
      expect(root_url(subdomain: nil)).to eq('http://example.com/')
    end
  end
  
  describe '#organization_url' do
    let(:organization) { create(:organization) }
    let(:url) { "http://#{organization.subdomain}.example.com/" }
    
    specify 'subdomain matches' do
      expect(controller.organization_url organization).to eq(url)
    end
    
    specify 'url_for organization' do
      expect(controller.url_for(organization)).to eq(url)
    end
  end
  
end