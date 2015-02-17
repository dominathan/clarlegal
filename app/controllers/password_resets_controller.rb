class PasswordResetsController < ApplicationController

  before_action :get_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash.now[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired. Please use 'Forgot Password?' to resend instructions."
      redirect_to new_password_reset_url
    elsif @user.update_attributes(user_params)
      if (params[:user][:password].blank? &&
          params[:user][:password_confirmation].blank?)
        flash.now[:danger] = "Password/confirmation can't be blank"
        render 'edit'
      else
        flash[:success] = "Password has been reset."
        sign_in @user
        redirect_to @user
      end
    else
      render 'edit'
    end
  end

  private

    def get_user
      @user = User.find_by(email: params[:email])
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
