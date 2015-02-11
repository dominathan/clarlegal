#Staffing refers to actual Staff for the lawfirm
#Staff refers to Case Staff... staff that work on a case
class StaffingsController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm

  def new
    @staffing = Staffing.new
    @lawfirm = current_user.lawfirm
  end

  def index
    @lawfirm = current_user.lawfirm
    @staffing = current_user.lawfirm.staffings.order(:last_name).load
  end

  def create
    @user = current_user
    @lawfirm = current_user.lawfirm
    @staffing = @lawfirm.staffings.new(staffing_params)
    #the following is a Client.method to store fullname in database
    @staffing.full_name = Client.full_name_last_first(params[:staffing][:first_name],
                                                    params[:staffing][:last_name])
    @staffing.position = params[:staffing][:new_position] unless params[:staffing][:new_position].empty?
    if @staffing.save
      flash[:success] = "Staff Added Successfully."
      redirect_to user_lawfirm_staffings_path(@user, @lawfirm)
    else
      render 'new'
    end
  end

  def show
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @staff = Staffing.find(params[:id])
    @closed_cases = Staffing.closed_cases_by_staffing(@staff.id)
    @open_cases = Staffing.open_cases_by_staffing(@staff.id)
  end

  def edit
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @staffing = Staffing.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @staffing = @lawfirm.staffings.find(params[:id])
    params[:staffing][:position] = params[:staffing][:new_position] unless params[:staffing][:new_position].empty?
    if @staffing.update_attributes(staffing_params)
      flash[:success] = "Staff Updated Successfully"
      redirect_to user_lawfirm_staffings_path(@user, @lawfirm)
    else
      render 'edit'
    end
  end

  #to show a staff member's revenue estimates, hours worked, timing estimates for each case
  def individuals_and_cases
    @user = current_user.id
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @staff = current_user.lawfirm.staffings.load
    @case = current_user.lawfirm.cases.load
    #for line graph of estimated fee over times
    if !@case.fees.empty?
      @fee_timeline = Fee.get_fee_dates(@case)
      @fee_high_estimates = Fee.get_fee_high_estimate(@case)
      @fee_medium_estimates = Fee.get_fee_medium_estimate(@case)
      @fee_low_estimates = Fee.get_fee_low_estimate(@case)
    end
    #for bargraph of hours worked
    @actual_hours = Staff.staff_total_hours_actual(@case.id,@staff.id)
    @expected_hours = Staff.staff_total_hours_expected(@case.id, @staff.id)
    @last_update = StaffCase.case_last_update(@case.id)
    #if case is closed, return items for graph of actual return
    if @case.open == false

    end
  end

  private

    def staffing_params
      params.require(:staffing).permit(:first_name, :last_name, :new_position, :position,
                                        :hourly_rate,:case_id_carryover, :middle_initial,
                                        :email)
    end

end
