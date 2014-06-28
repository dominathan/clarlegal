class PracticegroupsController < ApplicationController
  before_action :signed_in_user

  def new
    @prac_group = Practicegroup.new
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
  end

  def index
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @prac_group = Practicegroup.all
  end

  def create
    @user = User.find(params[:user_id])
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @prac_group = @lawfirm.practicegroups.new(practicegroup_params)
    if @prac_group.save
      flash[:success] = "Practice Group Added Succesfully."
      redirect_to user_lawfirm_practicegroups_path(@user,@lawfirm)
    else
      render 'new'
    end
  end

  def show
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @prac_group = Practicegroup.find(params[:id])
  end

  def edit
    @user = User.find(params[:user_id])
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @prac_group = Practicegroup.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @lawfirm = Lawfirm.find(params[:lawfirm_id])
    @prac_group = @lawfirm.practicegroups.find(params[:id])
    if @prac_group.update_attributes(practicegroup_params)
      flash[:success] = "Updated Group Name Successfully"
      redirect_to user_lawfirm_practicegroups_path(@user,@lawfirm)
    else
      render 'edit'
    end
  end

  private

    def practicegroup_params
      params.require(:practicegroup).permit(:group_name)
    end

end
