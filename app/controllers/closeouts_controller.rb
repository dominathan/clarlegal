class CloseoutsController < ApplicationController

  def new
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @closeout = Closeout.new
  end

  def create
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @closeout = @case.closeout.new(closeout_params)
    if @closeout.save
      Closeout.close_case(@case)
      flash[:success] = "Case Closed Successfully"
      redirect_to clients_path
    else
      render 'new'
    end
  end


  def edit
  end

  def show
  end

  private

    def closeout_params
       params.require(:closeout).permit(:total_revenue, :total_cost, :date)
    end
end
