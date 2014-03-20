# Be sure to restart your server when you modify this file.

# Puhsh::Application.config.session_store :cookie_store, key: '_puhsh_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
config =  YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]
Puhsh::Application.config.session_store :redis_store, config.symbolize_keys!
