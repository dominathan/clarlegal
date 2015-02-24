class CloseoutsController < ApplicationController
    before_action :signed_in_user, :belongs_to_firm
    before_action :set_case, :set_client, only: [:new, :create, :edit, :show, :update, :index]
    before_action :set_closeout, only: [:show, :edit, :update]

  def index
    @closeouts = @case.closeouts
  end

  def new
    @closeout = Closeout.new
  end

  def create
    @closeout = @case.closeouts.new(closeout_params)
    if @closeout.save
      Closeout.close_case(@case)
      flash[:success] = "Case Closed Successfully"
      redirect_to client_case_closeouts_path(@client,@case)
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @closeout.update_attributes(closeout_params)
      flash[:success] = "Update Closeout Information"
      redirect_to client_case_closeouts_path(@client, @case)
    else
      render 'edit'
    end
  end

  private

    def set_closeout
      @closeout = Closeout.find(params[:id])
    end

    def closeout_params
       params.require(:closeout).permit(:total_recovery, :total_gross_fee_received,
                                        :total_out_of_pocket_expenses, :referring_fees_paid,
                                        :total_fee_received, :date_fee_received, :fee_type)
    end
end
