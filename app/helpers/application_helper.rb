module ApplicationHelper
  include UrlHelper
  include AuthHelper
  
  def persist(model)
    if model.save
      render json: model
    else
      render json: model.errors.full_messages, status: 422
    end
  end
  
  def organization
    @organization ||= Organization.find_by!(subdomain: request.subdomains.first)
  end
  
  def fume_hoods
    organization.fume_hoods
  end
  
  def filters
    organization.filters
  end
  
  def filter_keys
    @filter_keys ||= filters.pluck(:key)
  end
end
