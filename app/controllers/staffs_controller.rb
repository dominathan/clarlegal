class StaffsController < ApplicationController
  before_action :signed_in_user

  def index
    @client = Client.find(params[:client_id])
    @case = Case.find(params[:case_id])
    @staff = @case.staff
    #to create pie chart of actual vs expected
    @actual_hours = StaffCase.case_total_hours_actual(@case.id)
    @expected_hours = StaffCase.case_total_hours_expected(@case.id)
    @last_update = StaffCase.case_last_update(@case.id)
  end


  def new
    @lawfirm = current_user.lawfirm
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @staff = Staff.new
  end

  def create
    @client = Client.find(params[:client_id])
    @case = Case.find(params[:case_id])
    @staff = @case.staff.new(staff_params)
    #@staff.staffing_id will cause problems when a lawfirm has people witht the same first and last name
    if @staff.save
      #add record to StaffCase because StaffCase is Master Record of all Case Staff
      StaffCase.create!(staffing_id: @staff.staffing_id, case_id: @case.id, current_case: true,
                    hours_expected: @staff.hours_expected || nil,
                    hours_actual: @staff.hours_actual || nil)
      flash[:success] = "Staff Added Successfully"
      #where should we go from here?
      redirect_to client_case_staffs_path(@client, @case)
    else
      render 'new'
    end
  end

  def show
    @lawfirm = current_user.lawfirm
    @staff = Staff.find(params[:id])
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
  end

  def edit
    @lawfirm = current_user.lawfirm
    @staff = Staff.find(params[:id])
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
  end

  def update
    @staff = Staff.find(params[:id])
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    if @staff.update_attributes(staff_params)
      #add record to StaffCase because StaffCase is Master Record of all Case Staff
      StaffCase.create!(staffing_id: @staff.staffing_id, case_id: @case.id, current_case: true,
                      hours_expected: @staff.hours_expected || nil,
                      hours_actual: @staff.hours_actual || nil)
      flash[:success] = "Staff Updated Successfully"
      redirect_to client_case_staffs_path(@client, @case)
    else
      render 'edit'
    end
  end

  def destroy
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @staff = Staff.find(params[:id])
    @staff.destroy
    #add record to StaffCase because StaffCase is Master Record of all Case Staff
    StaffCase.create!(staffing_id: @staff.staffing_id, case_id: @case.id, current_case: false,
                      hours_expected: @staff.hours_expected || nil,
                      hours_actual: @staff.hours_actual || nil)
    flash[:success] = "Staff Removed Successfully"
    redirect_to client_case_staffs_path(@client, @case)
  end

  private

    def staff_params
      params.require(:staff).permit(:name, :staffing_id, :position, :percent_utilization, :hours_expected, :hours_actual)
    end

end
