module ApiAuthHeaderGetters
  extend ActiveSupport::Concern

  included do
 
    # Get auth header values
    before_action :get_api_timestamp
    before_action :get_app_signature
    before_action :get_api_auth_token
    before_action :get_api_auth_signature
    
    # Pass auth headers
    before_action :ensure_auth_headers_are_passed

    def get_api_timestamp
      @timestamp_header_value = request.headers[::ApiConstants::API_HEADER_AUTH_TIMESTAMP]
      @timestamp_header_value
    end

    def get_app_signature
      @app_sig_header_value = request.headers[::ApiConstants::API_HEADER_APP_SIGNATURE_KEY]
      @app_sig_header_value
    end

    def get_api_auth_token
      @api_auth_token_value = request.headers[::ApiConstants::API_HEADER_TOKEN_KEY]
      @api_auth_token_value
    end

    def get_api_auth_signature
      @api_auth_signature_value = request.headers[::ApiConstants::API_HEADER_AUTH_SIGNATURE_KEY]
      @api_auth_signature_value
    end

    private

    def ensure_auth_headers_are_passed
      @timestamp_header_value ||= "posse"
      headers[::ApiConstants::API_HEADER_AUTH_TIMESTAMP] = @timestamp_header_value || ""
      ###This is same as of the last####
      headers[::ApiConstants::API_HEADER_AUTH_SIGNATURE_KEY] = @app_sig_header_value || ""
      headers[::ApiConstants::API_HEADER_TOKEN_KEY] = @api_auth_token || ""
      headers[::ApiConstants::API_HEADER_AUTH_SIGNATURE_KEY] = @api_auth_signature || ""
    end

  end

end