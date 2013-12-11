class RolesController < ApplicationController
  before_filter :authenticate_admin
  respond_to :json
  
  def index
    admins = organization.admins.map do |admin|
      { email: admin.email, type: 'admin' }
    end
    members = organization.members.map do |member|
      { email: member.email, type: 'member' }
    end
    render json: (admins + members).shuffle
  end
  
  def create
    email = params.require(:email)
    type = params.require(:type)
    user = User.parse(email)
    if type == 'admin'
      user.remove_role(:member, organization)
    end
    user.add_role(type, organization)
    render json: { email: email, type: type }
  end
  
  alias_method :update, :create
  
  def destroy
    user = User.find_by!(email: params[:id])
    user.remove_role(:member, organization)
    render json: { email: user.email }
  end

end