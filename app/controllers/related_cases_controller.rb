class RelatedCasesController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm, :set_client, :set_case

  def new
    @related_case = @case.related_cases.new
  end

  def create
    @related_case = @case.related_cases.new(related_cases_params)
    if @related_case.save
      flash[:success] = "Saved Related Case Successfully"
      redirect_to client_case_related_cases_path(@client,@case)
    else
      render 'new'
    end
  end

  def edit
    @related_case = RelatedCase.find(params[:id])
  end

  def update
    @related_case = RelatedCase.find(params[:id])
    if @related_case.update_attributes(related_cases_params)
      flash[:success] = "Updated Related Cases Succesfully"
      redirect_to client_case_related_cases_path(@client,@case)
    else
      render 'edit'
    end
  end

  def index
    @related_cases = @case.related_cases
  end

  def destroy
    RelatedCase.find(params[:id]).destroy
    flash[:success] = "Removed Related Case from #{@case.name}."
    redirect_to client_case_related_cases_path(@client,@case)
  end

  private

    def related_cases_params
      params.require(:related_case).permit(:related_case_id)
    end

end
