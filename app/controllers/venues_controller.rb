class VenuesController < ApplicationController
  before_action :signed_in_user

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  private

    def venue_params
      params.require(:venue).permit(:jurisdiction, :judge)
    end

end
