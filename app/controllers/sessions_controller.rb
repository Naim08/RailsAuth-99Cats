class SessionsController < ApplicationController
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

      redirect_to user_url(@user)
    else
      @user = User.new(username: user_params[:username])
      flash.now[:errors] = @user.errors.full_messages

      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
