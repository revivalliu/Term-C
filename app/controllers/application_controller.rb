class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def index
    if user_signed_in?
      # puts "\nCurrent User\n"
      # puts current_user.inspect
      # puts "\n\n"
      @user = current_user
      render "game_server/index"
    else
      redirect_to "/users/sign_in"
    end
  end
  protected 

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :preferred_server, :name) }
  end

end
