class OrganizationsController < ApplicationController
  before_filter :authenticate_user
  before_filter :authenticate_member, only: :dashboard
  before_filter :organization_redirect, only: :index
  
  layout :resolve_layout
    
  def dashboard
  end
  
  def index
  end
  
  private 
  
  def resolve_layout
    case action_name
    when 'dashboard'
      'application'
    else
      'static'
    end
  end
  
  def organization_redirect
    @organizations = current_user.has_role?(:admin) ? Organization.all : current_user.organizations
    if @organizations.empty?
      flash[:error] = 'You are not authorized for any registered organizations.'
      redirect_to root_path
    elsif @organizations.count == 1
      redirect_to @organizations.first
    end
  end
end