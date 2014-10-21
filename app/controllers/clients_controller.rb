class ClientsController < ApplicationController
  before_action :signed_in_user
  before_action :belongs_to_firm

  def index
    if params[:search] != nil
      clients = Client.search(params[:search], with: {user_id: current_user.id}, per_page: 1000).collect { |c| c.id }
      @client = Client.where(id: clients).paginate(per_page: 10, page: params[:page])
    else
      @client = Client.where(user_id: current_user.id).order(:last_name).paginate(per_page: 10, page: params[:page])
    end
  end

  def new
    @client = Client.new
    @client.billings.build
  end

  def edit
    @client = Client.find(params[:id])
    @client.billings.build
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
    @client.full_name = Client.full_name_last_first(params[:client][:first_name],
                                                    params[:client][:last_name])
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
      params.require(:client).permit(:first_name, :last_name, :street_address, :city,
                                      :state, :zip_code, :email,
                                      :phone_number, :fax_number, :different_billing,
                                      :billings_attributes => [:name, :street_address, :city, :state, :zip_code])
    end


end
