class CaseTypesController < ApplicationController

  def new
    @case_type = CaseType.new
  end

  def edit
    @case_type = CaseType.find(params[:id])
  end

  def show
    @case_type = CaseType.find(params[:id])
  end


  def index
    @case_types = current_user.lawfirm.case_types.load
  end

  def create
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @case_type = @lawfirm.case_types.new(case_type_params)
    if @case_type.save
      flash[:success] = "Matter Reference added Succesffuly to #{@lawfirm.firm_name}"
      redirect_to user_lawfirm_case_types_path(:user_id =>current_user.id,:lawfirm_id => current_user.lawfirm.id)
    else
      render 'new'
    end
  end

  def update

  end


  def import_matters
    begin
    if CaseType.import(params[:file],current_user)
      flash[:success] = "Matter Types Uploaded Successfully"
    end
    rescue
      flash[:danger] = "Matter Types Not Uploaded. Enter your information in the prescribed layout."
    end
    redirect_to user_lawfirm_case_types_path(current_user, current_user.lawfirm)
  end

  private


    def case_type_params
      params.require(:case_type).permit(:mat_ref)
    end


end
