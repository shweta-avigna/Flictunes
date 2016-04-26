class UserUpdateService
  attr_accessor :params, :user, :errors

  def initialize(user, params)
    @params = params
    @password = params[:password] || nil
    @user = user

    @errors = []
  end

  def process_update
    ActiveRecord::Base.transaction do
      passwordless_params = params_without_password_attribute
      update_user!(passwordless_params)
      set_password_if_possible!
    end
    return @user
  rescue => e
    @errors << e
    return nil
  end

  private
  def update_user!(passwordless_params)
    @user.update_attributes!(passwordless_params)
  end

  def set_password_if_possible!
    if @password
      password_authentication = @user.password_auth
      if password_authentication.nil?
        password_authentication = create_authentication!
      end
      password_authentication.set_password!(@password)
    end
  end

  def create_authentication!
    auth = @user.authentications.create!(
      service_type: Authentication::PASSWORD, 
    )
    auth
  end

  def params_without_password_attribute
    @params.except(:password)
  end

  def self.user_update_attributes
    attributes = {}
    if @first_name.present?
      attributes[:first_name]
    end
    if @last_name.present?
      attributes[:last_name]
    end
    if @email.present?
      attributes[:email]
    end
    if @username.present?
      attributes[:username]
    end
  end

end