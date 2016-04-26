class Api::V1::SessionsController < Api::V1::ApplicationController
	def new
		@resource = User.new
	end

	def signup_form
	  @resource = User.new
	end

  def signup
  	debugger
    service = UserSignupService.new(signup_params)
    @authentication = service.process_signup
    if @authentication.present?
      @user = @authentication.authable
      render :text => @user.to_json
      #return render_api_success("sessions/signup")
    else
      @errors = []
      @error_msg = { msg: service.errors.map(&:message).join(". ") }
      #Parse custom errors
      service.errors.each do |err|
        if err.class == CustomErrors::UserSignupEmailTaken
          @errors << { status: :user_signup_email_taken }
        elsif err.class == CustomErrors::UserSignupUsernameTaken
          @errors << { status: :user_signup_username_taken }
        end
      end
      @errors << { status: :validation_fail } 
      render :text => service.errors.to_json
    end
    
    return #render_api_error
  end

  def login
    email = login_params[:email]
    password = login_params[:password]
    if email.present?
      user = User.find_by(email: email)
      if user.present?
        if password.present?
          @user = User.login_with_password(email, password)
          if @user.present?
            return render_api_success("sessions/login")
          else
            @error_msg = { msg: "Email and password combination was incorrect" }
            @errors = [{ status: :user_login_email_and_password_invalid }]
          end
        else
          @error_msg = { msg: "Password cannot be empty" }
          @errors = [{ status: :invalid_param }]
        end
      else
        @error_msg = { msg: "An account with this email does not exist" }
        @errors = [{ status: :user_login_email_not_found }]
      end
    else
      @error_msg = { msg: "Email cannot be empty" }
      @errors = [{ status: :invalid_param }]
    end
    return render_api_error
  end

  def facebook
    access_token = facebook_params[:access_token]
    if access_token
      service = UserFacebookAuthenticationService.new(facebook_params)
      authentication = service.process_signup
      if authentication.present?
        @user = authentication.authable
        return render_api_success("sessions/login")
      else
        error = service.errors.first
        @error_msg = { msg: service.errors.map(&:message).join(". ") }
        if error.class == CustomErrors::FacebookAuthNoAssociatedAccountButEmailIsUsed
          @errors = [{ status: :facebook_auth_no_associated_account_but_email_is_used }]
        elsif error.class == CustomErrors::FacebookAuthNoAssociatedAccountAndEmailNotUsed
          @errors = [{ status: :facebook_auth_no_associated_account_and_email_not_used }]
        elsif error.class == CustomErrors::FacebookAuthUserDeniedEmailPermissions
          @errors = [{ status: :facebook_auth_user_denied_email_permissions }]
        else
          @errors = [{ status: :validation_fail }]
        end
      end
    else
      @error_msg = { :msg => "Sorry! We could not retrieve your Facebook access token" }
      @errors = [{ status: :missing_param }]
    end
    return render_api_error
  end

  private
  def signup_params
    params.permit(
      :email, 
      :first_name,
      :last_name,
      :username,
      :password, 
    )
  end

  def login_params
    params.permit(
      :email, 
      :password, 
    )
  end

  def facebook_params
    params.permit(
      :access_token, 
      :email, 
      :username, 
      :first_name, 
      :last_name, 
    )
  end

end
