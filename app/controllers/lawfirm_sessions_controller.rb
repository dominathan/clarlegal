class LawfirmSessionsController < ApplicationController
  before_action :signed_in_user

  def new
  end

  def create
    lawfirm = Lawfirm.find_by(firm_name: params[:lawfirm][:firm_name])
    if lawfirm && lawfirm.authenticate(params[:lawfirm][:password])
      user = current_user
      if user.update_attribute(:lawfirm_id, Lawfirm.find_by(firm_name: lawfirm.firm_name).id)
        flash.now[:success] = "You've successfully join #{@lawfirm}"
        redirect_to clients_path
      end
    else
      flash.now[:error] = 'Invalid Password'
      render 'new'
    end
  end

end
