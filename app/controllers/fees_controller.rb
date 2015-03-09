class FeesController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm

  def index
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @fee = @case.fees.order(:created_at)
    @fee_timeline = Fee.get_fee_dates(@case)
    @fee_high_estimates = Fee.get_fee_high_estimate(@case)
    @fee_medium_estimates = Fee.get_fee_medium_estimate(@case)
    @fee_low_estimates = Fee.get_fee_low_estimate(@case)
  end


  def new
    @fee = Fee.new
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
  end

  def create
    @client = Client.find(params[:client_id])
    @case = Case.find(params[:case_id])
    @fee = @case.fee.new(fee_params)
    @fee.referral_estimates
    if @fee.save
      flash[:success] = "Fee Added Successfully"
      redirect_to client_case_fees_path(@client, @case)
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
      @fee.referral_estimates
      if @fee.save
        flash[:success] = "Updated Fee Successfully"
        redirect_to client_case_fees_path(@client, @case)
      end
    else
      render 'edit'
    end
  end

  private

    def fee_params
      params.require(:fee).permit(:fee_type, :high_estimate, :medium_estimate,
                                  :low_estimate, :payment_likelihood, :retainer,
                                  :cost_estimate, :referral_percentage)
    end

end
