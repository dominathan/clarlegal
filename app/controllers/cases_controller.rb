class CasesController < ApplicationController
  before_action :signed_in_user
  before_action :belongs_to_firm

  def new
    @case = Case.new
    @client = Client.find(params[:client_id])
  end

  def new_case
    @case = Case.new
    @case.fees.build
    @case.staffs.build
    @case.timings.build
    @case.originations.build
    @case.checks.build
  end

  def create_case
    @case = Case.new(case_params)
    @case.court = params[:case][:new_court] unless params[:case][:new_court].empty?
    @case.judge = params[:case][:new_judge] unless params[:case][:new_judge].empty?
    @case.opposing_attorney = params[:case][:new_opposing_attorney] unless params[:case][:new_opposing_attorney].empty?
    unless params[:case][:new_type_of_matter].empty?
      @case.type_of_matter = params[:case][:new_type_of_matter]
      @new_matref = CaseType.create!(mat_ref: params[:case][:new_type_of_matter], lawfirm_id: current_user.lawfirm.id)
    end
    unless params[:case][:new_practice_group].empty?
      @case.practice_group = params[:case][:new_practice_group]
      @new_pg = Practicegroup.create!(group_name: params[:case][:new_practice_group], lawfirm_id: current_user.lawfirm.id)
    end
    unless params[:case][:originations_attributes]["0"][:new_referral_source].empty?
      @case.originations.first.referral_source = params[:case][:originations_attributes]["0"][:new_referral_source]
    end
    if @case.save
      Closeout.open_case(@case)
      unless params[:case][:originations_attributes]["0"][:new_referral_source].empty?
        @new_origination = Origination.create!(referral_source: params[:case][:originations_attributes]["0"][:new_referral_source],
                                              case_id: @case.id,
                                              source_description: params[:case][:originations_attributes]["0"][:source_description])
      end
      flash[:success] = "Case Added Successfully"
      redirect_to client_case_path(@case.client_id,@case)
    else
      render 'new_case'
    end
  end

  def index
    @client = current_user.clients.find(params[:client_id])
    if @client.cases.exists?
      @case = @client.cases.paginate(:page => params[:page], :per_page => 10 )
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
    @user = current_user
    if params[:search] != nil
      client_id_list = Case.client_id_list(current_user)
      case_list = Case.search(params[:search], with: { client_id: client_id_list}, page: 1, per_page: 1000).collect {|c|c.id}
      @case = Case.where(id: case_list).paginate(:page   => params[:page], :per_page => 10 )
    else
      @case = current_user.cases.paginate(:page   => params[:page], :per_page => 10 )
    end
  end

  private

    def case_params
        params.require(:case).permit(:client, :new_court, :court, :new_type_of_matter, :type_of_matter, :new_practice_group,
                                              :practice_group, :name, :open, :client_id, :case_number, :new_opposing_attorney,
                                              :opposing_attorney, :new_judge, :judge, :related_cases, :description, :user_id,
                                    :fees_attributes => [:fee_type, :high_estimate, :medium_estimate,
                                                          :low_estimate, :payment_likelihood, :retainer,
                                                          :cost_estimate, :referral],
                                    :staffs_attributes => [:name, :position, :percent_utilization, :hours_expected,
                                                           :hours_actual],
                                    :originations_attributes => [:new_referral_source, :referral_source, :source_description],
                                    :checks_attributes => [:conflict_check, :conflict_date, :referring_engagement_letter,
                                                            :referring_engagement_letter_date, :client_engagement_letter,
                                                            :client_engagement_letter_date],
                                    :timings_attributes => [:date_opened, :estimated_conclusion_fast,
                                                            :estimated_conclusion_expected,
                                                            :estimated_conclusion_slow, :case_filed])
    end



end
