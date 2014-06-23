class FeesController < ApplicationController
  before_action :signed_in_user

  def new
    @fee = Fee.new
  end

  def create
  end

  def edit
  end

  def update
  end

  private

    def fee_params
        params.require(:fee).permit(:fee_type, :high_estimate, :medium_estimate,
                                    :low_estimate, :payment_likelihood, :retainer,
                                    :cost_estimate)
    end

end
