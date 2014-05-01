source 'https://rubygems.org'
ruby '1.9.3'

gem 'puma'
gem 'pg'
gem 'rails', '4.0.0'
gem 'httparty'
gem 'resque', require: 'resque/server'
gem 'sparse_collection', github: 'glencrossbrunet/sparse_collection'

# auth
gem 'devise'
gem 'rolify'

# assets
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'neat'

# monitoring
gem 'newrelic_rpm'

# gem 'rabl'

group :production do
  gem 'rails_12factor'
  gem 'dalli'
  gem 'kgio'
end

group :development do
  gem 'annotate'
  gem 'letter_opener'
  gem 'quiet_assets'
  gem 'faker'
end

group :test do
  gem 'rspec-rails'
  gem 'diff_matcher'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'fuubar'
end
