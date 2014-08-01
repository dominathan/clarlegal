class CloseoutsController < ApplicationController

  def new
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @closeout = Closeout.new
  end

  def create
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @closeout = @case.closeouts.new(closeout_params)
    if @closeout.save
      Closeout.close_case(@case)
      flash[:success] = "Case Closed Successfully"
      redirect_to clients_path
    else
      render 'new'
    end
  end


  def edit
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @closeout = Closeout.find(params[:id])
  end

  def show
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @closeout = Closeout.find(params[:id])
  end

  def update
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @closeout = Closeout.find(params[:id])
    if @closeout.update_attributes(closeout_params)
      flash[:success] = "Update Closeout Information"
      redirect_to client_case_closeout_path(@client,@case,@closeout)
    else
      render 'edit'
    end
  end


  private

    def closeout_params
       params.require(:closeout).permit(:total_recovery, :total_gross_fee_received,
                                        :total_out_of_pocket_expenses, :referring_fees_paid,
                                        :total_fee_received, :date_fee_received)
    end
end
