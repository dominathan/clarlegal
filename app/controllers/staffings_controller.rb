class StaffingsController < ApplicationController
  before_action :signed_in_user

  def new
    @staffing = Staffing.new
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
  end

  def index
    @staffing = Staffing.all.order(:last_name).paginate(page: params[:page], per_page: 15)
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
  end

  def create
    @user = User.find(params[:user_id])
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @staff = @lawfirm.staffings.new(staffing_params)
    #the following is a Client.method to store fullname in database
    @staff.full_name = Client.full_name_last_first(params[:staffing][:first_name],
                                                    params[:staffing][:last_name])
    @staff.position = params[:staffing][:new_position] unless params[:staffing][:new_position].empty?
    if @staff.save
      flash[:success] = "Staff Added Successfully."
      redirect_to user_lawfirm_staffings_path(@user, @lawfirm)
    else
      render 'new'
    end
  end

  def show
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @staff = Staffing.find(params[:id])
  end

  def edit
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @staff = Staffing.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @staff = @lawfirm.staffings.find(params[:id])
    if @staff.update_attributes(staffing_params)
      flash[:success] = "Staff Updated Successfully"
      redirect_to user_lawfirm_staffings_path(@user, @lawfirm)
    else
      render 'edit'
    end
  end

  private

    def staffing_params
      params.require(:staffing).permit(:first_name, :last_name, :new_position, :position, :hourly_rate)
    end

end
