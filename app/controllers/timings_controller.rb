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

  def show
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @timing = Timing.find(params[:id])
  end

  def edit
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @timing = Timing.find(params[:id])
  end

  def update
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @timing = Timing.find(params[:id])
    if @timing.update_attributes(timing_params)
      flash[:success] = "Dates Updated"
      redirect_to client_case_path(@client, @case)
    else
      render 'edit'
    end
  end




  private

      def timing_params
        params.require(:timing).permit(:date_opened, :estimated_conclusion_date, :key_date)
      end

end
