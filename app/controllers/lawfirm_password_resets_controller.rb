class LawfirmPasswordResetsController < ApplicationController
  before_action :get_user, :get_lawfirm, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:lawfirm_password_reset][:email].downcase)
    if @user
      @lawfirm = @user.lawfirm
      if @lawfirm && @lawfirm.user_id == @user.id
        @lawfirm.create_reset_digest
        @user.send_lawfirm_password_reset_email
        flash[:info] = "Email sent with password reset instructions"
        redirect_to index_lawfirm_users_user_lawfirm_path(current_user.id, current_user.lawfirm.id)
      else
        flash.now[:danger] = "Email address is not authorized to reset the password.  Please contact your administrator or email us at admin@clarlegal.com"
      end
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @lawfirm.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_lawfirm_password_reset_url
      binding.pry
    elsif @lawfirm.update_attributes(lawfirm_params)
      binding.pry
      if (params[:lawfirm][:password].blank? &&
          params[:lawfirm][:password_confirmation].blank?)
        flash.now[:danger] = "Password/confirmation can't be blank"
        render 'edit'
      else
        flash[:success] = "Password has been reset."
        redirect_to index_lawfirm_users_user_lawfirm_path(current_user.id, current_user.lawfirm.id)
      end
    else
      render 'edit'
    end
  end

  private
    def get_user
      @user = User.find_by(email: params[:email])
      unless (@user && @user.activated?)
        redirect_to root_url
      end
    end

    def get_lawfirm
      @lawfirm = Lawfirm.find_by(user_id: User.find_by(email: params[:email]).id)
    end

    def lawfirm_params
      params.require(:lawfirm).permit(:password, :password_confirmation)
    end
end
