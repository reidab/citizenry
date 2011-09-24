# Be sure to restart your server when you modify this file.

Citizenry::Application.config.session_store :cookie_store, :key => SETTINGS[:session_cookie_key] || '_citizenry_app_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Citizenry::Application.config.session_store :active_record_store
