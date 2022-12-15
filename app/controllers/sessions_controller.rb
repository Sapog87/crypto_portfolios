class SessionsController < ApplicationController
  before_action :authorized, except: [:delete, :create]

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to @user
    else
      redirect_to new_session_path
    end
  end

  def delete
    session[:user_id] = nil
    redirect_to new_session_path
  end
end
