class PracticegroupsController < ApplicationController
  before_action :signed_in_user

  def new
  end

  def index
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  private

    def practicegroup_params
      params.require(:practicegroup).permit(:group_name)
    end

end
