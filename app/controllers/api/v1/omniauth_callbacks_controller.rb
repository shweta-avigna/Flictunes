class Api::V1::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
		@user = User.from_omniauth(request.env["omniauth.auth"])
     if @user.persisted?
       flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "facebook"
       sign_in_and_redirect @user
     else
       session["devise.user_attributes"] = @user.attributes
       redirect_to new_user_registration_url
     end
  end
end
