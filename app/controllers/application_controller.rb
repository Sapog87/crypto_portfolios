class ApplicationController < ActionController::Base
  include Pagy::Backend

  rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  rescue_from ActionController::RoutingError, with: :rescue404

  before_action :current_user

  helper_method :logged_in?, :current_user

  def current_user
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    redirect_to @user if logged_in?
  end

  def exists
    rescue404 unless !!User.exists?(params[:id])
  end

  def rescue404
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end
end
