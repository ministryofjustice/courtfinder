# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Courtfinder::Application.config.secret_token = Rails.env.production? ? ENV["SESSION_SECRET_KEY"] : "3c1c638b115edba065da04e99e236eae"

