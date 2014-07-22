class CasesController < ApplicationController
  before_action :signed_in_user
  before_action :belongs_to_firm

  def new
    @case = Case.new
    @client = Client.find(params[:client_id])
  end

  def new_case
    @case = Case.new
  end

  def create_case
    @case = Case.new(case_params)
    @case.client_id = Client.find_by(client_name: params[:case][:client]).id
    if @case.save
      Closeout.open_case(@case)
      flash[:success] = "Case Added Successfully"
      redirect_to client_case_path(@case.client_id,@case)
    else
      render 'new_case'
    end
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
      Closeout.open_case(@case) #set case.open = true
      flash[:success] = "Case Added Successfully"
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
        params.require(:case).permit(:matter_reference, :description, :practice_group, :name, :open, :client_id)
    end

end
