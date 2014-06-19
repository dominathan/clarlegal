class ClientsController < ApplicationController

  def new
    @client = Client.new
  end

  def show
    @client = Client.find_by(params[:id])
  end


  def create
    @client = Client.new(client_params)
    if @client.save
      flash[:success] = "Client added sucessfully"
      redirect_to new_client_path
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

  private

    def client_params
      params.require(:client).permit(:client_name, :client_street_address, :client_city_address,
                                      :client_state_address, :client_zip_code)
    end


end