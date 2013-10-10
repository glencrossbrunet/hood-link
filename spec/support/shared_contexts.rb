shared_context 'admin of organization' do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  before { request.host = "#{organization.subdomain}.example.com" }
  before { sign_in :user, user }
  before { user.add_role(:admin, organization) }
end