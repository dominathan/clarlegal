class TimingsController < ApplicationController
  before_action :signed_in_user

  def new
    @timing = Timing.new
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
  end

  def create
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @timing = @case.timing.new(timing_params)
    if @timing.save
      flash[:success] = "Important Dates Added Successfully"
      redirect_to client_case_path(@client, @case)
    else
      render 'new'
    end
  end


  private

      def fee_params
        params.require(:timing).permit(:date_opened, :estimated_conclusion_date, :key_date)
      end

end
