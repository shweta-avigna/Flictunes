module JsonOutput
  extend ActiveSupport::Concern

  included do 
    #layout "api_v1"
    helper_method :api_status
    helper_method :api_error
  end

  # Standard API return blocks  
  def render_api_success(view="/app/generic")
    @has_error = false
    render :template => "#{view_path}#{ensure_leading_slash(view)}", formats: [:json, :tjson]
  end
  
  def render_api_error(view="/app/errors")
    @has_error = true
    @errors ||= [{ status: :unknown_error }]
    render :template => "#{view_path}#{ensure_leading_slash(view)}", formats: [:json, :tjson]
  end

  # API Timestamp
  def render_api_timestamp_missing
    Rails.logger.error "ERROR: API Timestamp header is missing"
    @has_error = true
    @status = :authentication_failed
    @errors = [{:status => :api_timestamp_missing}]
    render :template => "#{view_path}/app/errors", formats: [:json, :tjson]
  end

  def render_api_timestamp_invalid
    Rails.logger.error "ERROR: API Timestamp header is expired or invalid"
    @has_error = true
    @status = :authentication_failed
    @errors = [{:status => :api_timestamp_invalid}]
    render :template => "#{view_path}/app/errors", formats: [:json, :tjson]
  end

  # APP Signature
  def render_app_signature_missing
    Rails.logger.error "ERROR: App Signature header is missing"
    @has_error = true
    @status = :authentication_failed
    @errors = [{:status => :app_signature_missing}]
    render :template => "#{view_path}/app/errors", formats: [:json, :tjson]
  end

  def render_app_signature_invalid
    Rails.logger.error "ERROR: App Signature header is invalid"
    @has_error = true
    @status = :authentication_failed
    @errors = [{:status => :app_signature_invalid}]
    render :template => "#{view_path}/app/errors", formats: [:json, :tjson]
  end

  # API Auth Token
  def render_api_auth_token_missing
    Rails.logger.error "ERROR: API Auth Token header is missing"
    @has_error = true
    @status = :authentication_failed
    @errors = [{:status => :api_auth_token_missing}]
    render :template => "#{view_path}/app/errors", formats: [:json, :tjson]
  end

  def render_api_auth_token_invalid
    Rails.logger.error "ERROR: API Auth Token header is invalid"
    @has_error = true
    @status = :unauthorized
    @errors = [{:status => :api_auth_token_invalid}]
    render :template => "#{view_path}/app/errors", formats: [:json, :tjson]
  end

  def render_api_auth_token_stale
    Rails.logger.error "ERROR: API Auth Token header is stale"
    @has_error = true
    @status = :unauthorized
    @errors = [{:status => :auth_failed}]
    render :template => "#{view_path}/app/errors", 
      status: 401, 
      formats: [:json, :tjson]
  end

  # API Auth Signature
  def render_api_auth_signature_missing
    Rails.logger.error "ERROR: API Auth Signature header is missing"
    @has_error = true
    @status = :authentication_failed
    @errors = [{:status => :api_auth_signature_missing}]
    render :template => "#{view_path}/app/errors", formats: [:json, :tjson]
  end

  def render_api_auth_signature_invalid
    Rails.logger.error "ERROR: API Auth Signature header is invalid"
    @has_error = true
    @status = :unauthorized
    @errors = [{:status => :api_auth_signature_invalid}]
    render :template => "#{view_path}/app/errors", formats: [:json, :tjson]
  end

  # Alert Types
  def alert_type
    return {
      :sticky => "sticky",
      :show_once => "show_once",
      :dismissible => "dismissible", 
    }
  end

  # API Status Codes
  def api_status
    return {
      :ok => { :code => 200, :msg => nil },
      :unauthorized => { :code => 401, :msg => "Unauthorized" },
      :api_error => { :code => 500, :msg => "Request has errors" }
    }
  end
  
  # API Error Codes
  def api_error
    return {
      # Generic
      :unknown_error => { :code => 6666, :msg => "Server Error" },
      # Authentication/ Authorization Errors
      :unauthorized => { :code => 6000, :msg => "Unauthorized" },
      :auth_failed => { :code => 6001, :msg => "Authentication failed" },
      :user_not_authorized => { :code => 6002, :msg => "User unauthorized for action" }, 
      # API Timestamp
      :api_timestamp_missing => { :code => 6003, :msg => "API Timestamp is missing" },
      :api_timestamp_invalid => { :code => 6004, :msg => "API Timestamp is expired or invalid"}, 
      # App Signature
      :app_signature_missing => { :code => 6005, :msg => "App Signature is missing" },
      :app_signature_invalid => { :code => 6006, :msg => "App Signature is not authorized or invalid" },
      # API Auth Token
      :api_auth_token_missing => { :code => 6007, :msg => "API Auth Token is missing" },
      :api_auth_token_invalid => { :code => 6008, :msg => "API Auth Token is not authorized or invalid" },
      # API Auth Signature
      :api_auth_signature_missing => { :code => 6009, :msg => "API Auth Signature is missing" },
      :api_auth_signature_invalid => { :code => 6010, :msg => "API Auth Signature is not authorized or invalid" },
      # SMS
      :code_token_invalid => { :code => 6011, :msg => "SMS code or token is invalid."},
      :sms_code_missing => { :code => 6012, :msg => "Missing required sms access code" },
      :sms_token_missing => { :code => 6013, :msg => "Missing required sms access token" },
      # Parameter Errors
      :validation_fail => { :code => 7000, :msg => "Parameters failed validation" },
      :missing_param => { :code => 7001, :msg => "Missing required parameter" },
      :invalid_param => { :code => 7002, :msg => "Invalid parameter" },
      # Resource Errors
      :resource_not_found => { :code => 8000, :msg => "Requested resource not found" },
      :invalid_resource => { :code => 8001, :msg => "A requested resource was invalid" },
      # Third Party
      :braintree_client_token_error => { :code => 9000, :msg => "Failed to generate braintree client token" },
      # Facebook Auth
      :facebook_access_token_invalid => { :code => 9001, :msg => "Invalid Facebook access token" },
      :facebook_auth_no_associated_account_but_email_is_used => { code: 9002, msg: "Facebook ID was not associated with an account, "\
        "but email is already attached to an existing account" }, 
      :facebook_auth_no_associated_account_and_email_not_used => { code: 9003, msg: "Facebook ID was not associated with an account, "\
        "and email is not already attached to an existing account" }, 
      :facebook_auth_user_denied_email_permissions => { :code => 9004, :msg => "User denied email permissions for Facebook and "\
        "has not yet supplied an email and username" },
      # Custom Signup Errors
      :user_signup_email_taken => { :code => 5000, :msg => "User provided email is already taken" },
      :user_signup_username_taken => { :code => 5001, :msg => "User provided username is already taken" },
      # Custom Login Errors
      :user_login_email_not_found => { :code => 5500, :msg => "A Flictunes account with this email does not exist" },
      :user_login_email_and_password_invalid => { :code => 5501, :msg => "Email and password combination was incorrect" },
    }
  end

  private
  def view_path(path=nil)
    "/api/v1#{ensure_leading_slash(path)}"
  end

  def ensure_leading_slash(path)
    path = '/' + path if !path.nil? && path.first != '/'
    path
  end

end