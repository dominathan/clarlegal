class StaffsController < ApplicationController
  before_action :signed_in_user

  def new
    @lawfirm = current_user.lawfirm
    @staff = Staff.new
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
  end

  def create
    @client = Client.find(params[:client_id])
    @case = Case.find(params[:case_id])
    @staff = @case.staff.new(staff_params)
    if @staff.save
      flash[:success] = "Staff added sucessfully"
      #where should we go from here?
      redirect_to client_case_path(@client, @case)
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
      flash[:success] = "Staff Updated Successfully"
      redirect_to client_case_path(@client, @case)
    else
      render 'edit'
    end
  end

  private

    def staff_params
      params.require(:staff).permit(:responsible_attorney, :assigned_attorney_1, :assigned_attorney_2,
                                    :assigned_staff_1, :assigned_staff_2)
    end

end
