module AuthHelper
  
  def user_admin?
    user_signed_in? && current_user.has_role?(:admin, organization)
  end  
  
  def user_member?
    user_signed_in? && current_user.has_role?(:member, organization) || user_admin?
  end
  
  def authenticate_user
    forbidden! unless user_signed_in?
  end
  
  def authenticate_admin
    forbidden! unless user_admin?
  end
  
  def authenticate_member
    forbidden! unless user_member?
  end
  
  def forbidden!
    sign_out :user if user_signed_in?
    redirect_to new_user_session_path
  end
  
  def organization
    @organization ||= Organization.find_by!(subdomain: request.subdomains.first)
  end
  
end