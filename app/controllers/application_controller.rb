class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= begin 
      User.find(session[:user_id])
    end
  end

  def logged_in?
    session[:user_id].present?
  end

  def login_required
    if !logged_in?
      redirect_to new_session_url
      false
    else
      true
    end
  end
end
