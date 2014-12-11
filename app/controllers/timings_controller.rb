class TimingsController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm

  def index
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
  end

  def new
    @timing = Timing.new
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
  end

  def create
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @timing = @case.timing.new(timing_params)
    #convert estimated conclusions from integers to dates for consistency in graph model/controller
    unless timing_params['estimated_conclusion_fast'].empty?
      #if length is > 3 then Class is Date and can be saved
      if timing_params['estimated_conclusion_fast'].length < 3
        @timing.estimated_conclusion_fast = Date.today + (timing_params['estimated_conclusion_fast']).to_i.month
      end
    end
    unless timing_params['estimated_conclusion_expected'].empty?
      if timing_params['estimated_conclusion_expected'].length < 3
        @timing.estimated_conclusion_expected = Date.today + (timing_params['estimated_conclusion_expected']).to_i.month
      end
    end
    unless timing_params['estimated_conclusion_slow'].empty?
      if timing_params['estimated_conclusion_slow'].length < 3
        @timing.estimated_conclusion_slow = Date.today + (timing_params['estimated_conclusion_slow']).to_i.month
      end
    end
    if @timing.save
      flash[:success] = "Important Dates Added Successfully"
      redirect_to client_case_timings_path(@client, @case)
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
    @timing.estimated_conclusion_fast = Date.today + (timing_params['estimated_conclusion_fast']).to_i.month
    @timing.estimated_conclusion_expected = Date.today + (timing_params['estimated_conclusion_expected']).to_i.month
    @timing.estimated_conclusion_slow = Date.today + (timing_params['estimated_conclusion_slow']).to_i.month
    if @timing.update_attributes(timing_params)
      flash[:success] = "Dates Updated"
      redirect_to client_case_timings_path(@client, @case)
    else
      render 'edit'
    end
  end

  private

      def timing_params
        params.require(:timing).permit(:date_opened, :estimated_conclusion_fast,
                                      :estimated_conclusion_expected,
                                      :estimated_conclusion_slow, :case_filed)
      end



end
