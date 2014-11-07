class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = "Account activated!"
      sign_in user
      redirect_to joinlawfirm_path
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
