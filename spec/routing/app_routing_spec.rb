require 'spec_helper'

describe 'routes' do
  
  specify 'GET /' do
    expect({ get: '/' }).to route_to({ controller: 'devise/sessions', action: 'new' })
  end
  
end