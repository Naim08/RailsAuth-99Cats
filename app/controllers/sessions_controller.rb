class SessionsController < ApplicationController
  before_action :require_logged_out, only: %i[new create]
  before_action :require_logged_in, only: [:destroy]
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      user_params[:username],
      user_params[:password]
    )

    if @user
      login!(@user)
      redirect_to user_url(@user)
    else
      @user = User.new(username: user_params[:username])
      flash.now[:errors] = @user.errors.full_messages

      render :new
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
