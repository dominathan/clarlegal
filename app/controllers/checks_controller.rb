class ChecksController < ApplicationController
  before_action :signed_in_user

  def new
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @check = Check.new
  end

  def create
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @check = @case.checks.new(check_params)
    if @check.save
      flash[:success] = "Check Dates Added Successfully."
      redirect_to client_case_check_path(@client, @case, @check)
    else
      render 'new'
    end
  end

  def show
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @check = Check.find(params[:id])
  end

  def edit
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @check = Check.find(params[:id])
  end

  def update
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @check = Check.find(params[:id])
    if @check.update_attributes(check_params)
      flash[:success] = "Updated Check Dates Successfully"
      redirect_to client_case_check_path(@client, @case, @check)
    else
      render 'edit'
    end
  end

  private

    def check_params
      params.require(:check).permit(:conflict_check, :conflict_date, :referring_engagement_letter,
                                    :referring_engagement_letter_date, :client_engagement_letter,
                                    :client_engagement_letter_date)
    end


end
