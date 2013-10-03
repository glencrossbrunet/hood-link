class Organization < ActiveRecord::Base
  validates :subdomain,
    uniqueness: true,
    format: { with: /\A[a-z0-9]+(-[a-z0-9]+)*\Z/ }
end
