# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
HoodLink::Application.config.secret_key_base = if Rails.env.production?
  ENV['RAILS_SECRET_TOKEN']
else
  'cba400dc285e4cf6840ef00ea52c67503445d08aa52e6691f2d11ee89f117380ac08426205193b33a72d884a978ec0c9e24e3b3351e513967a6154dc88eaf665'
end
