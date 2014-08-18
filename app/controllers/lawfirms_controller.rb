class LawfirmsController < ApplicationController
  before_action :signed_in_user

  def new
    @lawfirm = Lawfirm.new
    @user = User.find(params[:user_id])
  end

  def create #on creation, need to add lawfirm_id to the user index
    @lawfirm = Lawfirm.new(lawfirm_params)
    @user = User.find(params[:user_id])
    if @lawfirm.save
      flash[:success] = "#{@lawfirm.firm_name} created successfully"
    end
    if @user.update_attribute(:lawfirm_id, Lawfirm.find_by(firm_name: @lawfirm.firm_name).id)
      redirect_to new_user_lawfirm_staffing_path(current_user.id,current_user.lawfirm.id)
    else
      render 'new'
    end
  end

  def edit
  end

  def show
    @lawfirm = Lawfirm.find(params[:id])
  end

  def index
    @firm_name = current_user.lawfirm.firm_name
    @lawfirm_clients = current_user.lawfirm.clients.paginate(:page => params[:page], per_page: 10)
  end

  def show_lawfirm_cases
    @firm_name = current_user.lawfirm.firm_name
    @lawfirm_cases = current_user.lawfirm.cases.paginate(:page => params[:page], per_page: 20)  #this is the paginate form
  end

  private

  def lawfirm_params
    params.require(:lawfirm).permit(:firm_name, :password, :password_confirmation)
  end

end
