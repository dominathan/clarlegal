class CasesController < ApplicationController
  before_action :signed_in_user

  def new
    @case = Case.new
    @client = Client.find(params[:client_id])
    #@params = params.inspect
  end

  def index
    @client = current_user.clients.find(params[:client_id])
    if @client.cases.exists?
      @case = @client.cases.all
    end
  end

  def create
    current_client = Client.find(params[:client_id])
    @case = current_client.cases.new(case_params)
    if @case.save
      flash[:success] = "Case added sucessfully"
      redirect_to client_cases_path
    else
      render 'new'
    end
  end

  def update
    current_client = Client.find(params[:client_id])
    client_case = current_client.cases.find(params[:id])
    if client_case.update_attributes(case_params)
      flash[:success] = "Updated case matter information"
      redirect_to client_cases_path
    else
      render 'edit'
    end
  end

  def edit
    current_client = Client.find(params[:client_id])
    @case = current_client.cases.find(params[:id])
  end

  def destroy
  end

  private

    def case_params
        params.require(:case).permit(:matter_reference, :description, :practice_group)
    end

end
