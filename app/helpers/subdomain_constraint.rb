module SubdomainConstraint
  
  def matches?(request)
    subdomains = request.subdomains
    subdomains.length == 1 && Organization.exists?(subdomain: subdomains.first)
  end
  
  extend self
end