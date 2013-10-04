# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
<<<<<<< HEAD
HoodLink::Application.config.secret_key_base = '264488c6a3eda69d84abd65cc1cf22d0562547fbb28fd7920312cb7d0b0946b6c82c8b913fefc191f2fe741f08729acbbfe8bf0fda9ccf0e51c1eb8f1cf65dfe'
=======

FumeHoods::Application.config.secret_key_base = ENV['RAILS_SECRET_TOKEN']
>>>>>>> previous
