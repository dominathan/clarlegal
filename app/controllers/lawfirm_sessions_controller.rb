class LawfirmSessionsController < ApplicationController
  before_action :signed_in_user

  def new
  end

  def create
    @lawfirm = Lawfirm.find_by(params[:firm_name])
    if @lawfirm.authenticate(params[:password])
      flash.now[:success] = "You've successfully join #{@lawfirm}"
      redirect_to clients_path
    else
      flash.now[:error] = 'Invalid Password'
      render 'new'
    end
  end

end
