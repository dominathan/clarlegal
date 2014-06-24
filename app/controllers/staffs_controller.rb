class StaffsController < ApplicationController
  before_action :signed_in_user

  def new
    @staff = Fee.new
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
  end

  def create
    @client = Client.find(params[:client_id])
    @case = Case.find(params[:case_id])
    @staff = @case.staff.new(staff_params)
    if @staff.save
      flash[:success] = "Fee structure added sucessfully"
      #where should we go from here?
      redirect_to client_case_path(@client, @case)
    else
      render 'new'
    end
  end

  private

    def staff_params
      params.require(:staff).permit(:responsible_attorney, :assigned_attorney_1, :assigned_attorney_2,
                                    :assigned_staff_1, :assigned_staff_2)
    end

end
