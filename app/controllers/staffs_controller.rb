class StaffsController < ApplicationController
  before_action :signed_in_user

  def index
    @client = Client.find(params[:client_id])
    @case = Case.find(params[:case_id])
    @staff = @case.staff
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
    @staff.staffing_id = Staffing.find_by(:full_name => staff_params[:name]).id
    #this will cause problems when multiple last names enter the picture
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
      params.require(:staff).permit(:name, :position, :percent_utilization, :hours_expected, :hours_actual)
    end

end
