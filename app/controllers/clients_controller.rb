class ClientsController < ApplicationController

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      flash[:success] = "Client added sucessfully"
      redirect_to @client
    else
      render 'new'
      flash[:error] = "Please fix the fields below"
    end
  end

      #FROM USER CREATE------
          #   def create
          #   @user = User.new(user_params)
          #   if @user.save
          #     sign_in @user
          #     flash[:success] = "Welcome"
          #     redirect_to @user
          #   else
          #     render 'new'
          #   end
          # end

end
