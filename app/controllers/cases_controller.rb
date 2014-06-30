class CasesController < ApplicationController
  before_action :signed_in_user
  before_action :belongs_to_firm

  def new
    @case = Case.new
    @client = Client.find(params[:client_id])
  end

  def index
    @client = current_user.clients.find(params[:client_id])
    if @client.cases.exists?
      @case = @client.cases.all
    end
  end

  def create
    @client = Client.find(params[:client_id])
    @case = @client.cases.new(case_params)
    if @case.save
      flash[:success] = "Case added sucessfully"
      redirect_to client_case_path(@client,@case)
    else
      render 'new'
    end
  end

  def update
    @client = Client.find(params[:client_id])
    @case = @client.cases.find(params[:id])
    if @case.update_attributes(case_params)
      flash[:success] = "Updated case matter information"
      redirect_to client_case_path(@client,@case)
    else
      render 'edit'
    end
  end

  def edit
    @client = Client.find(params[:client_id])
    @case = @client.cases.find(params[:id])
  end

  def show
    @client = Client.find(params[:client_id])
    @case = @client.cases.find(params[:id])
  end


  def destroy
  end

  def user_cases
    @case = current_user.cases
  end

  private

    def case_params
        params.require(:case).permit(:matter_reference, :description, :practice_group)
    end

end
