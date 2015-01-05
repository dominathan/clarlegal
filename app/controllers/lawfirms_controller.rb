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
      @user.update_attribute(:lawfirm_id, @lawfirm.id) && current_user.lawfirm.update_attribute(:user_id, current_user.id)
      redirect_to user_cases_path(@user)
    else
      render 'new'
    end
  end

  def edit
    @lawfirm = Lawfirm.find(params[:id])
  end

  def update
    @lawfirm = Lawfirm.find(params[:id])
    if @lawfirm.authenticate(params[:old_password][:old_password])
      if @lawfirm.update_attributes(lawfirm_params)
        flash[:success] = "Firm Updated Successfully"
        redirect_to index_lawfirm_users_user_lawfirm_path(current_user.id, current_user.lawfirm.id)
      else
        flash[:danger] = "Fix the following errors."
        render 'edit'
      end
    else
      flash[:danger] = "Password is incorrect"
      render 'edit'
    end
  end

  def show
    @lawfirm = Lawfirm.find(params[:id])
  end

  def index
    @firm_name = current_user.lawfirm.firm_name
    @lawfirm_clients = current_user.lawfirm.clients.order(:last_name).load
  end

  def show_lawfirm_cases
    @firm_name = current_user.lawfirm.firm_name
    @lawfirm_cases = current_user.lawfirm.cases.load  #this is the paginate form
  end

  # Allow lawfirm creator to have admin access to who views what
  def index_lawfirm_users
    if current_user.id == current_user.lawfirm.user_id
      @users = User.where(lawfirm_id: current_user.lawfirm.id).load
    else
      flash[:danger] = "You must have administrative privileges to view this page."
      redirect_to user_cases_path
    end
  end

  #Lawfirm Admin grants access to lawfirm users to view dashboard
  def toggle_dashboard
    user = User.find(params[:id])
    if params[:dashboard_access] == "true" && user.dashboard_access == false || user.dashboard_access == nil
      respond_to do |format|
        if user.update_attribute(:dashboard_access, 1)
          format.html { render :nothing => true, :notice => "Updated Dashboard Access."}
          format.js { render :nothing => true, :notice => "Updated Dashboard Access"}
        else
          @users = User.where(lawfirm_id: current_user.lawfirm.id).load
          format.html { render :action => 'index_lawfirm_users', :notice => "We were not able to offer dashboard access at this time.  Please email admin@clarlegal.com if this persists." }
          format.js { render :action => 'index_lawfirm_users', :notice => "We were not able to offer dashboard access at this time.  Please email admin@clarlegal.com if this persists."}
        end
      end
    elsif params[:dashboard_access] == "false" && user.dashboard_access == true || user.dashboard_access = nil
      respond_to do |format|
        if user.update_attribute(:dashboard_access, 0)
          format.html { render :nothing => true, :notice => "Updated Dashboard Access."}
          format.js { render :nothing => true, :notice => "Updated Dashboard Access"}
        else
          @users = User.where(lawfirm_id: current_user.lawfirm.id).load
          format.html { render :action => 'index_lawfirm_users', :notice => "We were not able to offer dashboard access at this time.  Please email admin@clarlegal.com if this persists." }
          format.js { render :action => 'index_lawfirm_users', :notice => "We were not able to offer dashboard access at this time.  Please email admin@clarlegal.com if this persists."}
        end
      end
    end
  end

  private

    def lawfirm_params
      params.require(:lawfirm).permit(:firm_name, :password, :password_confirmation, :user_id)
    end

end
