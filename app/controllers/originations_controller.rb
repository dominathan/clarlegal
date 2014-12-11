class OriginationsController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm

  def new
    @origination = Origination.new
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
  end

  def create
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @origination = @case.origination.new(origination_params)
    if @origination.save
      flash[:success] = "Origination Added to Case"
      redirect_to client_case_originations_path(@client, @case)
    else
      render 'new'
    end
  end

  def show
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @origination = Origination.find(params[:id])
  end

  def edit
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @origination = Origination.find(params[:id])
  end

  def update
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @origination = Origination.find(params[:id])
    if @origination.update_attributes(origination_params)
      flash[:success] = "Updated Origination Successfully"
      redirect_to client_case_origination_path(@client, @case, @origination)
    else
      render 'edit'
    end
  end

  private

    def origination_params
      params.require(:origination).permit(:referral_source, :source_description)
    end


end
