module CustomErrors

  FACEBOOK_AUTHENTICATION_FAILED = "Facebook authentication failed"

  class FacebookAuthenticationFailedError < StandardError
    def initialize(message=FACEBOOK_AUTHENTICATION_FAILED)
      super
    end
  end

  class FacebookAuthNoAssociatedAccountButEmailIsUsed < StandardError
    def initialize(message=FACEBOOK_AUTHENTICATION_FAILED)
      super
    end
  end
  
  class FacebookAuthNoAssociatedAccountAndEmailNotUsed < StandardError
    def initialize(message=FACEBOOK_AUTHENTICATION_FAILED)
      super
    end
  end

  class FacebookAuthUserDeniedEmailPermissions < StandardError
    def initialize(message=FACEBOOK_AUTHENTICATION_FAILED)
      super
    end
  end

  USER_SIGNUP_FAILED = "User signup failed"

  class UserSignupEmailTaken < StandardError
    def initialize(message=USER_SIGNUP_FAILED)
      super
    end
  end

  class UserSignupUsernameTaken < StandardError
    def initialize(message=USER_SIGNUP_FAILED)
      super
    end
  end

end