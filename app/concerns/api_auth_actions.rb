module ApiAuthActions
  extend ActiveSupport::Concern

  included do

    def get_authenticated_user
      if @authenticated_user.nil?
        if @authentication_id.present?
          authentication = Authentication.find(@authentication_id)
          @authenticated_user = authentication.authable
          @authenticated_user
        else
          nil
        end
      else
        @authenticated_user
      end
    end

    def is_me?
      get_authenticated_user
      if @authenticated_user.present?
        if [@authenticated_user.pubid, "me"].include? params[:id]
          return true
        elsif [@authenticated_user.pubid, "me"].include? params[:user_id]
          return true
        end
      end
      return false
    end
    
  end
end