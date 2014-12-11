class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = "We're excited to have you! Please enter your law firm's information if it has already been registered.\n
                        If you are the first user, enter the required information in the fields below to protect your data."
      sign_in user
      redirect_to new_user_lawfirm_path(user)
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
