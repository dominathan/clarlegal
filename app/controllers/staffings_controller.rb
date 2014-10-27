#Staffing refers to actual Staff for the lawfirm
#Staff refers to Case Staff... staff that work on a case
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

  #to show a staff members revenue estimates, hours worked, timing estimates for each case
  def individuals_and_cases
    @user = current_user.id
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @staff = Staffing.find(params[:id])
    @case = Case.find(params[:case_id])
    #for line graph of estimated fee over times
    @fee_timeline = Fee.get_fee_dates(@case)
    @fee_high_estimates = Fee.get_fee_high_estimate(@case)
    @fee_medium_estimates = Fee.get_fee_medium_estimate(@case)
    @fee_low_estimates = Fee.get_fee_low_estimate(@case)
    #for bargraph of actual hours worked
    @actual_hours = Staff.staff_total_hours_actual(@case.id,@staff.id)
    @expected_hours = Staff.staff_total_hours_expected(@case.id, @staff.id)
    @last_update = StaffCase.case_last_update(@case.id)
  end

  private

    def staffing_params
      params.require(:staffing).permit(:first_name, :last_name, :new_position, :position,
                                        :hourly_rate,:case_id_carryover)
    end

end
