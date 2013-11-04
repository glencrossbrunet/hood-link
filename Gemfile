source 'https://rubygems.org'
ruby '1.9.3'

gem 'thin'
gem 'pg'
gem 'rails', '4.0.0'
gem 'httparty'
gem 'resque', require: 'resque/server'
gem 'sparse_collection', github: 'glencrossbrunet/sparse_collection'

# auth
gem 'devise'
gem 'rolify', '~> 3.3.0.rc4'

# assets
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'neat'

# gem 'rabl'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'annotate'
  gem 'letter_opener'
  gem 'quiet_assets'
  gem 'faker'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'fuubar'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
