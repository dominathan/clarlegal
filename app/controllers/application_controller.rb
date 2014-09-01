class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    def belongs_to_firm
      unless current_user.lawfirm
        redirect_to new_user_lawfirm_path(current_user.id)
        flash[:error] = "You must join or create a lawfirm."
      end
    end


    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, :flash => { :error => "You must sign in."}
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end


    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
