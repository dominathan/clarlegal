class CasesController < ApplicationController
  before_action :signed_in_user

  def new
    @case = Case.new
    @client = Client.find(params[:client_id])
    #@params = params.inspect
  end

  def index
    @case = Case.all
  end

  def create
    current_client = Client.find(params[:client_id])
    @case = current_client.cases.new(case_params)
    if @case.save
      flash[:success] = "Client added sucessfully"
      redirect_to clients_path
    else
      render 'new'
    end
  end

  def udpate
  end

  def edit
  end

  def destroy
  end

  private

    def case_params
        params.require(:case).permit(:matter_reference, :description, :practice_group)
    end

end
