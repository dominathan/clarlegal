class BillingsController < ApplicationController
  def new
    @billing = Billing.new
    @client = Client.find(params[:client_id])
  end

  def create
    @client = Client.find(params[:client_id])
    @billing = @client.billings.new(billing_params)
    if @billing.save
      flash[:success] = "Billing Information Added Successfully"
      redirect_to root_path
    else
      render 'new'
    end
  end


  private

    def billing_params
      params.require(:billing).permit(:name, :street_address, :city, :state, :zip_code, :client_id)
    end

end
