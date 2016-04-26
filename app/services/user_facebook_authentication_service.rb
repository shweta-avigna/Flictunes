class UserFacebookAuthenticationService
  attr_accessor :facebook_params, :user, :facebook_authentication, :errors

  def initialize(facebook_params)
    @facebook_params = facebook_params
    @access_token = facebook_params[:access_token] || nil
    @email = facebook_params[:email] || nil
    @username = facebook_params[:username] || nil

    @user = nil 
    @facebook_authentication = nil
    @errors = []
  end

  def process_signup
    ActiveRecord::Base.transaction do
      facebook_uid = get_facebook_uid_from_access_token
      @facebook_authentication = Authentication.fetch_or_create_for_facebook!(facebook_uid)
      @user = @facebook_authentication.authable
      if @user.present? 
        # Facebook auth is already associated with an account
        # Return the user's facebook auth because it is a successful login
      elsif @user.nil? 
        # Facebook auth is NOT associated with an acc
        if @email.present? 
          # Email permissions were accepted by user
          existing_user = User.find_by(email: @email)
          if existing_user.present? 
            # Email is already taken
            error_message = "Sorry, email is taken. Please login with your existing account"
            raise CustomErrors::FacebookAuthNoAssociatedAccountButEmailIsUsed.new(error_message)
          else 
            # Email is not already taken
            if @username.present?
              create_user_with_password_auth!
            elsif @username.blank?
              error_message = "Please enter a username to continue"
              raise CustomErrors::FacebookAuthNoAssociatedAccountAndEmailNotUsed.new(error_message)
            end
          end
        elsif @email.blank? 
          # Email permissions were denied by user
          error_message = "Please enter an email and username to continue"
          raise CustomErrors::FacebookAuthUserDeniedEmailPermissions.new(error_message)
        end
      end
    end
    return @facebook_authentication
  rescue => e
    @errors << e
    return nil
  end

  private
  def get_facebook_uid_from_access_token
    client = Aye::Facebook::Client.new(@access_token)
    data = client.debug_user_access_token
    if data.present?
      facebook_uid = data["user_id"]
    else
      error_messages = client.errors.map(&:message).join(". ")
      raise CustomErrors::FacebookAuthenticationFailedError.new(error_messages)
    end
    return facebook_uid
  end

  def create_user_with_password_auth!
    service = UserSignupService.new(facebook_params, password_is_required=false)
    password_auth = service.process_signup
    if password_auth
      add_facebook_auth_to_user!(password_auth)
    else
      error_messages = service.errors.map(&:message).join(". ")
      raise CustomErrors::FacebookAuthenticationFailedError.new(error_messages)
    end
  end

  def add_facebook_auth_to_user!(password_auth)
    @user = password_auth.authable
    @facebook_authentication.authable_id = @user.id
    @facebook_authentication.authable_type = @user.class
    @facebook_authentication.save!
  end

end