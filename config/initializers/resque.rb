require 'yaml'

if Rails.env.production?
  Resque.redis = ENV["REDISCLOUD_URL"]
end

Resque::Server.use(Rack::Auth::Basic) do |user, password|
  user == 'admin'
  password == 'GlenBrown2'
end