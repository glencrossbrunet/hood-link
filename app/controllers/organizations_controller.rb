class OrganizationsController < ApplicationController
  before_filter :authenticate_member
  
  def dashboard
  end
  
end