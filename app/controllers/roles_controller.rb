class RolesController < ApplicationController
  before_filter :authenticate_admin
  
  respond_to :json
  
  def index
    members = organization.members.map do |member|
      { email: member.email, type: 'member' }
    end
    
    admins = organization.admins.map do |admin|
      { email: admin.email, type: 'admin' }
    end
    
    respond_with(members + admins)
  end
  
  def destroy
    member = User.find_by!(email: params[:id])
    member.remove_role(:member, organization)
    respond_with({ email: member.email })
  end

end