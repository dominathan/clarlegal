class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        flash[:success] = "Welcome to ClarLegal"
        sign_in user
        user.sign_in_incrementer
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user_cases_path
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out if signed_in?
    redirect_to root_url
  end

end
