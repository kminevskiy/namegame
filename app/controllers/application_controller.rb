class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :unauthenticated?, :logged_in_user

  def current_user
    session[:user_id]
  end

  def logged_in_user
    User.find_by(id: current_user) if current_user
  end

  def unauthenticated?
    redirect_to(login_path) && return if !current_user
  end
end
