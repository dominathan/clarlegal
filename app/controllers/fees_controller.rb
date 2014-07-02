#need to update controller action.  A FEE should only be "Updated", if
# client mis-types the data on the inital request.  Otherwise, each "update"
# should make a "new" data object with the same CaseID, but a "new" Fee ID.
# These can be shown with timestamps for a graphical representation of the data.

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
    @fee = @case.fee.new(fee_params)
    if @fee.save
      flash[:success] = "Fee Added Successfully"
      redirect_to client_case_path(@client, @case)
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
      redirect_to client_case_path(@client, @case)
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
