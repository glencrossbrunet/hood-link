module UrlHelper
  def host_with(subdomain)
    subdomain = request.subdomains.push(subdomain).uniq.join('.')
    puts subdomain
    subdomain += '.' unless subdomain.blank?
    [ subdomain, *request.subdomains, request.domain, request.port_string ].join
  end
  
  def url_for(options = nil)
    if options.is_a?(Hash) && options.has_key?(:subdomain)
      options[:host] = host_with options.delete(:subdomain)
    end
    super
  end
  
  def organization_url(organization, options={})
    root_url(options.merge(subdomain: organization.subdomain))
  end
  
  alias_method :organization_path, :organization_url
end