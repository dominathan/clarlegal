class VenuesController < ApplicationController
  before_action :signed_in_user

  def new
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @venue = Venue.new
  end

  def create
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @venue = @client.venue.new(venue_params)
    if @venue.save
      flash[:success] = "Venue Added to Case"
      redirect_to client_case_path(@client, @case)
    else
      render 'new'
    end
  end

  def show
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @venue = Venue.find(params[:id])
  end

  def edit
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @venue = Venue.find(params[:id])
  end

  def update
    @case = Case.find(params[:case_id])
    @client = Client.find(params[:client_id])
    @venue = Venue.find(params[:id])
    if @venue.update_attributes(venue_params)
      flash[:success] = "Updated Venue Successfully"
      redirect_to client_case_path(@client, @case)
    else
      render 'edit'
    end
  end

  private

    def venue_params
      params.require(:venue).permit(:jurisdiction, :judge)
    end

end
