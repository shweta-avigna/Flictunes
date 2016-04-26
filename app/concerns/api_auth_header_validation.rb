module ApiAuthHeaderValidation
  extend ActiveSupport::Concern

  included do

    # Skip rails authenticity token check
    skip_before_action :verify_authenticity_token, if: :json_request?

    before_action :validate_presence_of_api_timestamp
    before_action :validate_presence_of_app_signature
    before_action :validate_presence_of_api_auth_token_and_signature

    # Validate header values
    before_action :validate_api_timestamp
    before_action :validate_app_signature
    before_action :validate_api_auth_token_and_signature

    private
    
    def json_request?
      request.format.json?
    end

    ################
    # Overrides
    ################
    def api_should_authenticate?
      !is_safe_env?
    end
    
    def is_safe_env?
      Rails.env.development? || Rails.env.staging?
    end

    # TODO: Remove in production
    def should_override_api_timestamp?
      (@timestamp_header_value == "posse")? true : false
    end

    ################
    # Timestamp
    ################
    def validate_presence_of_api_timestamp
      if @timestamp_header_value.blank?
        return render_api_timestamp_missing
      end
    end

    def validate_api_timestamp
      if !should_override_api_timestamp?
        timestamp_header_value_epoch = @timestamp_header_value.to_i
        timestamp_expiration_value_epoch = ::ApiConstants::API_TIMESTAMP_EXPIRATION_MINS.minutes.ago.to_i
        if timestamp_header_value_epoch < timestamp_expiration_value_epoch
          return render_api_timestamp_invalid
        end
      else
        Rails.logger.warn "WARNING: API Timestamp was overriden and bypassed"
      end
    end

    ################
    # App Signature
    ################
    def validate_presence_of_app_signature
      if @app_sig_header_value.blank?
        return render_app_signature_missing
      end
    end

    def validate_app_signature
      validator = AppTokenValidator.new(@app_sig_header_value, @timestamp_header_value, ::ApiConstants::API_SECRET)
      if !validator.is_info_valid?
        return render_app_signature_invalid
      end
    end

    ########################
    # Auth Token/ Signature
    ########################
    def validate_presence_of_api_auth_token
      if @api_auth_token_value.blank?
        return render_api_auth_token_missing
      end
    end

    def validate_presence_of_api_auth_signature
      if @api_auth_signature_value.blank?
        return render_api_auth_token_missing
      end
    end

    def validate_presence_of_api_auth_token_and_signature
      return validate_presence_of_api_auth_token
      return validate_presence_of_api_auth_signature
    end

    def validate_api_auth_token_and_signature
      validator = AuthTokenValidator.new(
        @api_auth_token_value, 
        @api_auth_signature_value, 
        @timestamp_header_value, 
        ::ApiConstants::API_SECRET
      )
      if validator.is_info_valid?
        # Check cache for user id and continue
        @authentication_id = $redis_auth.get(validator.auth_token)
        if @authentication_id.present?
          Rails.logger.info "Auth ID #{@authentication_id} found in cache. Continuing..."
        else
          Rails.logger.warn "Auth API Token was not found in cache..."
          authentication = Authentication.find_by_api_token(validator.auth_token)
          if authentication.present?
            @authentication_id = authentication.id
          else
            return render_api_auth_token_stale
          end
        end
      else
        return render_api_auth_token_invalid
      end
    end

    def validate_api_token_and_continue_if_missing
      Rails.logger.warn "API Auth Token or Signature is not required for this endpoint. Continuing..."
      if @api_auth_token_value && @api_auth_signature_value
        Rails.logger.warn "API Auth Token or Signature was provided anyway. Continuing..."        
        return validate_api_auth_token_and_signature
      end
    end
    
  end
end