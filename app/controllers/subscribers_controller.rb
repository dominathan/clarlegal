class SubscribersController < ApplicationController

  def create
    @subscriber = Subscriber.new(subscriber_params)
    if @subscriber.save
      SubscriptionMailer.demo_request(@subscriber.email).deliver!
      flash[:success] = "Thanks for your interest in our product. We will be in touch shortly."
      redirect_to root_path
    else
      redirect_to root_path
      flash[:alert] = "Please review the errors below."
    end
  end

  private

    def subscriber_params
      params.require(:subscriber).permit(:email)
    end

end
