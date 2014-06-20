class ClientsController < ApplicationController
  before_action :signed_in_user

  def index
    @client = Client.all
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find(params[:id])
  end

  def show
    @client = Client.find(params[:id])
  end


  def create
    @client = current_user.clients.build(client_params)
    if @client.save
      flash[:success] = "Client added sucessfully"
      redirect_to clients_path
    else
      render 'new'
      flash[:error] = "Please fix the fields below"
    end
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(client_params)
      flash[:success] = "Updated client information"
      redirect_to clients_path
    else
      render 'edit'
    end
  end

  private

    def client_params
      params.require(:client).permit(:client_name, :client_street_address, :client_city_address,
                                      :client_state_address, :client_zip_code, :client_email)
    end


end
