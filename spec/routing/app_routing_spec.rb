require 'spec_helper'

describe 'app routes' do
  
  specify 'GET /' do
    expect(get: '/').to route_to(controller: 'static', action: 'welcome')
  end
  
  specify 'GET /organizations' do
    expect(get: '/organizations').to route_to(controller: 'organizations', action: 'index')
  end
    
end