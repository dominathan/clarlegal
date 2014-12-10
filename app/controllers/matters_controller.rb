class MattersController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm, :set_client, :set_case

  def index
    @matter = @case.matters
  end

  def new
    @matter = @case.matters.new
  end

  def create
    @matter = @case.matters.new(matter_params)
    if @matter.save
      flash[:success] = "Add Matter Type Successfully"
      redirect_to client_case_matters_path(@client,@case)
    else
      render 'new'
    end
  end

  def edit
    @matter = Matter.find(params[:id])
  end

  def update
    @matter = Matter.find(params[:id])
    if @matter.update_attributes(matter_params)
      flash[:success] = "Add Matter Type Successfully"
      redirect_to client_case_matters_path(@client,@case)
    else
      render 'new'
    end
  end

  def destroy
    Matter.find(params[:id]).destroy
    flash[:success] = "Removed Matter Type from #{@case.name}."
    redirect_to client_case_matters_path(@client,@case)
  end

    private

      def matter_params
        params.require(:matter).permit(:case_type_id)
      end


end
