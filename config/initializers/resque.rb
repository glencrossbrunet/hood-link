if Rails.env.production?
  Resque.redis = ENV["REDISCLOUD_URL"]
end