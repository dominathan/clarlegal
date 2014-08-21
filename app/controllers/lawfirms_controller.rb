class LawfirmsController < ApplicationController
  before_action :signed_in_user

  def new
    @lawfirm = Lawfirm.new
    @user = User.find(params[:user_id])
  end

  def create #on creation, need to add lawfirm_id to the user index
    @lawfirm = Lawfirm.new(lawfirm_params)
    @user = User.find(params[:user_id])
    if @lawfirm.save
      flash[:success] = "#{@lawfirm.firm_name} created successfully"
    end
    if @user.update_attribute(:lawfirm_id, Lawfirm.find_by(firm_name: @lawfirm.firm_name).id)
      redirect_to new_user_lawfirm_staffing_path(current_user.id,current_user.lawfirm.id)
    else
      render 'new'
    end
  end

  def edit
  end

  def show
    @lawfirm = Lawfirm.find(params[:id])
  end
  #temporary disabled .search method for thinking sphinx until enabled in either:
    #Heroku with fliyng-sphinx purchase or
    #deployed to productino
  def index
    @firm_name = current_user.lawfirm.firm_name
    # if params[:search] != nil
    #   @firm_name = current_user.lawfirm.firm_name
    #   user_id_list = current_user.lawfirm.user_ids
    #   clients = Client.search(params[:search], with: {user_id: user_id_list}, per_page: 1000).collect { |c| c.id }
    #   @lawfirm_clients = Client.where(id: clients).paginate(per_page: 10, page: 1)
    # else
      @lawfirm_clients = current_user.lawfirm.clients.paginate(:page => params[:page], per_page: 10)
    # end
  end

  def show_lawfirm_cases
    @firm_name = current_user.lawfirm.firm_name
    # if params[:search] != nil
    #   client_id_list = Case.client_id_list_of_lawfirm(current_user)
    #   lawfirm_cases_ids = Case.search(params[:search], with: {client_id: client_id_list}, page: 1, per_page: 1000).collect{ |c| c.id }
    #   @lawfirm_cases = Case.where(:id => lawfirm_cases_ids).paginate(:per_page => 15, :page => params[:page])
    # else
      @lawfirm_cases = current_user.lawfirm.cases.paginate(:page => params[:page], per_page: 15)  #this is the paginate form
    # end
  end

  private

  def lawfirm_params
    params.require(:lawfirm).permit(:firm_name, :password, :password_confirmation)
  end

end
