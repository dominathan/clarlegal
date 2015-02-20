#Staffing refers to actual Staff for the lawfirm
#Staff refers to Case Staff... staff that work on a case
class StaffingsController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm, :set_lawfirm

  def new
    @staffing = @lawfirm.staffings.build
  end

  def index
    @staffing = @lawfirm.staffings.order(:last_name).load
  end

  def create
    @staffing = @lawfirm.staffings.new(staffing_params)
    #the following is a Client.method to store fullname in database
    @staffing.full_name = Client.full_name_last_first(params[:staffing][:first_name],
                                                    params[:staffing][:last_name])
    @staffing.position = params[:staffing][:new_position] unless params[:staffing][:new_position].empty?
    if @staffing.save
      flash[:success] = "Staff Added Successfully."
      redirect_to user_lawfirm_staffings_path(current_user, @lawfirm)
    else
      render 'new'
    end
  end

  def show
    @staff = Staffing.find(params[:id])
    @closed_cases = Staffing.closed_cases_by_staffing(@staff.id)
    @open_cases = Staffing.open_cases_by_staffing(@staff.id)
  end

  def edit
    @staffing = Staffing.find(params[:id])
  end

  def update
    @staffing = @lawfirm.staffings.find(params[:id])
    params[:staffing][:position] = params[:staffing][:new_position] unless params[:staffing][:new_position].empty?
    if @staffing.update_attributes(staffing_params)
      flash[:success] = "Staff Updated Successfully"
      redirect_to user_lawfirm_staffings_path(current_user, @lawfirm)
    else
      render 'edit'
    end
  end

  def import_staffing
    begin
    if Staffing.import(params[:file],current_user)
      flash[:success] = "Staff Uploaded Successfully"
    end
    rescue
      flash[:danger] = "Staff Not Uploaded. Enter your information in the prescribed layout."
    end
    redirect_to user_lawfirm_staffings_path(current_user, @lawfirm)
  end

  private

    def staffing_params
      params.require(:staffing).permit(:first_name, :last_name, :new_position, :position,
                                        :hourly_rate,:case_id_carryover, :middle_initial,
                                        :email)
    end

end
