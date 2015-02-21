class ClientsController < ApplicationController
  before_action :signed_in_user
  before_action :belongs_to_firm

  def index
    @clients = Client.where(user_id: current_user.id).order(:last_name).load
  end

  def new
    @client = Client.new
    @client.billings.build
  end

  def edit
    @client = Client.find(params[:id])

  end

  #added profitability metrics to view client as compared to average of all clients
  def show
    @client = Client.find(params[:id])
    @profitability = Client.client_profitability_actual(@client)
    all_client_profitability = Client.all_client_profitability(current_user)
    @avg_profitability = Client.avg_client_profitability(all_client_profitability)
  end


  def create
    @client = current_user.clients.build(client_params)
    if @client.save
      flash[:success] = "Client Added Successfully"
      redirect_to clients_path
    else
      render 'new'
    end
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(client_params)
      flash[:success] = "Updated Client Information"
      redirect_to clients_path
    else
      render 'edit'
    end
  end

  def import_clients
    begin
    if Client.import(params[:file],current_user)
      flash[:success] = "Clients Uploaded Successfully"
    end
    rescue
      flash[:danger] = "Clients Not Uploaded. Enter your information in the prescribed layout."
    end
    redirect_to user_lawfirms_path(current_user) #user lawfirms path is index of clients.
  end

  private

    def client_params
      params.require(:client).permit(:company, :first_name, :last_name, :street_address, :city,
                                      :state, :zip_code, :country, :email,
                                      :phone_number, :fax_number, :different_billing,
                                      :billings_attributes => [:name, :street_address, :city, :state, :zip_code])
    end


end
