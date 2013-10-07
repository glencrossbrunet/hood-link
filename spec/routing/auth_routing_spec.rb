require 'spec_helper'

describe 'auth routes' do
  
  specify 'no user registration' do
    expect(get: '/users/sign_up').not_to be_routable
    expect(post: '/users').not_to be_routable
    expect(delete: '/users').not_to be_routable
  end
  
  specify 'no confirmation' do
    expect(get: '/users/confirmation/new').not_to be_routable
    expect(post: '/users/confirmation').not_to be_routable
  end
  
  specify 'sign in' do
    expect(get: '/users/sign_in').to route_to(controller: 'devise/sessions', action: 'new')
    expect(post: '/users/sign_in').to route_to(controller: 'devise/sessions', action: 'create')
  end
  
end