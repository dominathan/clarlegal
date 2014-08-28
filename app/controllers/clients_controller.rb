class ClientsController < ApplicationController
  before_action :signed_in_user
  before_action :belongs_to_firm

  def index
    if params[:search] != nil
      clients = Client.search(params[:search], with: {user_id: current_user.id}, per_page: 1000).collect { |c| c.id }
      @client = Client.where(id: clients).paginate(per_page: 10, page: 1)
    else
      @client = Client.where(user_id: current_user.id).paginate(per_page: 10, page: 1)
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
      params.require(:client).permit(:first_name, :last_name, :street_address, :city,
                                      :state, :zip_code, :email,
                                      :phone_number, :fax_number, :different_billing,
                                      :billings_attributes => [:name, :street_address, :city, :state, :zip_code])
    end


end
