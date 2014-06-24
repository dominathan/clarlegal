class FeesController < ApplicationController
  before_action :signed_in_user

  def new
    @fee = Fee.new
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
  end

  def create
    @client = Client.find(params[:client_id])
    @case = Case.find(params[:case_id])
    @fee = @case.fees.new(fee_params)
    if @fee.save
      flash[:success] = "Case added sucessfully"
      #where should we go from here?
      redirect_to client_case_fee_path(@client, @case, @fee)
    else
      render 'new'
    end
  end

  def show
    @fee = Fee.find(params[:id])
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
  end


  def edit
    @fee = Fee.find(params[:id])
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
  end

  def update
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @fee = Fee.find(params[:id])
    if @fee.update_attributes(fee_params)
      flash[:success] = "Updated Fee Successfully"
      redirect_to client_cases_path
    else
      render 'edit'
    end
  end

  private

    def fee_params
        params.require(:fee).permit(:fee_type, :high_estimate, :medium_estimate,
                                    :low_estimate, :payment_likelihood, :retainer,
                                    :cost_estimate)
    end

end
