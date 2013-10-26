module SubdomainConstraint
  
  def matches?(request)
    subdomains = request.subdomains
    if Rails.env.production?
      subdomains.length == 2 && Organization.exists?(subdomain: subdomains.first)
    else
      subdomains.length == 1 && Organization.exists?(subdomain: subdomains.first)
    end
  end
  
  extend self
end