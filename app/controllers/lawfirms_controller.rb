class LawfirmsController < ApplicationController
  before_action :signed_in_user

  def new
    @lawfirm = Lawfirm.new
    @user = User.find(params[:id])
  end

  def create #on creation, need to add lawfirm_id to the user index
    @lawfirm = Lawfirm.new(lawfirm_params)
    @user = User.find(params[:user_id])
    if @lawfirm.save
      flash[:success] = "#{@lawfirm} created successfully"
      @user.lawfirm_id = @lawfirm.id
      redirect_to clients_path
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
    @lawfirm = Lawfirm.all
  end

  private

  def lawfirm_params
    params.require(:lawfirm).permit(:firm_name, :password, :password_confirmation)
  end

end
