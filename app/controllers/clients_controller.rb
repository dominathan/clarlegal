class ClientsController < ApplicationController
  before_action :signed_in_user

  def index
    @client = Client.all.paginate(:page => params[:page], per_page: 10)
  end

  def new
    @client = Client.new
    @client.billings.build
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
                                          :client_state_address, :client_zip_code, :client_email,
                                          :client_phone_number, :client_fax_number, :different_billing,
                                      :billings_attributes => [:name, :street_address, :city, :state, :zip_code])
    end


end
