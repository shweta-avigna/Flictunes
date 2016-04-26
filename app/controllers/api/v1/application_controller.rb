class Api::V1::ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
   include JsonOutput
  #protect_from_forgery with: :exception
   after_filter :set_csrf_cookie

  def set_csrf_cookie
    if protect_against_forgery?
      cookies['XSRF-TOKEN'] = form_authenticity_token
    end
  end
  
  def current_user
  	if session[:user].present?
  		session[:user]
  	end
  	nil
  end
  helper_method :current_user
end
