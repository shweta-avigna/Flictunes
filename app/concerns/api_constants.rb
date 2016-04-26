module ApiConstants
  extend ActiveSupport::Concern

  # Timestamp Headers
  API_HEADER_AUTH_TIMESTAMP = Rails.application.secrets.api_header_timestamp_key
  API_TIMESTAMP_EXPIRATION_MINS = Rails.application.secrets.api_timestamp_expiration_mins

  # App Signature Headers
  API_HEADER_APP_SIGNATURE_KEY = Rails.application.secrets.api_header_app_sig_key

  # Auth Token/ Signature Headers
  API_HEADER_TOKEN_KEY = Rails.application.secrets.api_header_token_key
  API_HEADER_AUTH_SIGNATURE_KEY = Rails.application.secrets.api_header_auth_sig_key

  # Device Headers
  APP_HEADER_DEVICE_DENSITY_KEY = Rails.application.secrets.api_header_device_density
  APP_HEADER_DEVICE_TYPE_KEY = Rails.application.secrets.api_header_device_type
  APP_HEADER_DEVICE_DIMENSIONS_KEY = Rails.application.secrets.api_header_device_dimensions

  # API secret. This should never be shared to users / externally. must be the same in the client app.
  API_SECRET = Rails.application.secrets.api_auth_secret

end