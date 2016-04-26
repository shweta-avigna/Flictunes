class UserSignupService
  attr_accessor :params, :user, :authentication, :errors

  USERNAME_TAKEN_ERR = "Username has already been taken"
  EMAIL_TAKEN_ERR = "Email has already been taken"

  def initialize(params, password_is_required=true)
    @first_name = params[:first_name] || nil
    @last_name = params[:last_name] || nil
    @email = params[:email] || nil
    @username = params[:username] || nil
    @password = params[:password] || nil
    @password_is_required = password_is_required

    @user = nil
    @authentication = nil
    @errors = []
  end

  def process_signup
    ActiveRecord::Base.transaction do
      @user = create_user!
      debugger
      @authentication = @user.create_password_auth!
      # Facebook signup does not require a password initially
      if @password_is_required
        success = @authentication.set_password!(@password)
      end
    end
    return @authentication
  rescue => e
    if e.class == ActiveRecord::RecordInvalid
      return parse_and_check_custom_validation_errors(e)
    else
      @errors << e
      return nil
    end
  end

  private
  def create_user!
    user = User.new(
      first_name: @first_name, 
      last_name: @last_name, 
      email: @email, 
      username: @username, 
    )
    user.save!
    user
  end

  def parse_and_check_custom_validation_errors(e)    
    error_message = e.message
    if error_message =~ /\A.*#{EMAIL_TAKEN_ERR}.*#{USERNAME_TAKEN_ERR}.*\z/
      @errors << CustomErrors::UserSignupEmailTaken.new(EMAIL_TAKEN_ERR)
      @errors << CustomErrors::UserSignupUsernameTaken.new(USERNAME_TAKEN_ERR)
    elsif error_message =~ /\A.*#{USERNAME_TAKEN_ERR}.*#{EMAIL_TAKEN_ERR}.*\z/
      @errors << CustomErrors::UserSignupEmailTaken.new(EMAIL_TAKEN_ERR)
      @errors << CustomErrors::UserSignupUsernameTaken.new(USERNAME_TAKEN_ERR)
    elsif error_message =~ /#{EMAIL_TAKEN_ERR}\z/
      @errors << CustomErrors::UserSignupEmailTaken.new(EMAIL_TAKEN_ERR)
    elsif error_message =~ /#{USERNAME_TAKEN_ERR}\z/
      @errors << CustomErrors::UserSignupUsernameTaken.new(USERNAME_TAKEN_ERR)
    else
      @errors << e
    end
    return nil
  end

end