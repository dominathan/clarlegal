class CasesController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm

  def new_case
    new_case_material
    @case.fees.build
    @case.timings.build
    @case.checks.build
  end

  def create_case
    new_create_case_objects
    #timings must be converted fromintegers to dates to correctly calculate timing in graph models and controller
    unless params[:case]['timings_attributes']['0']['estimated_conclusion_fast'].empty?
      #if length > 3..its Class is Date and can be saved without conversion
      if params[:case]['timings_attributes']['0']['estimated_conclusion_fast'].length < 3
        @case.timings.first.estimated_conclusion_fast = Date.today + (params[:case]['timings_attributes']['0']['estimated_conclusion_fast']).to_i.month
      end
    end
    unless params[:case]['timings_attributes']['0']['estimated_conclusion_expected'].empty?
      if params[:case]['timings_attributes']['0']['estimated_conclusion_expected'].length < 3
        @case.timings.first.estimated_conclusion_expected = Date.today + (params[:case]['timings_attributes']['0']['estimated_conclusion_expected']).to_i.month
      end
    end
    unless params[:case]['timings_attributes']['0']['estimated_conclusion_slow'].empty?
      if params[:case]['timings_attributes']['0']['estimated_conclusion_slow'].length < 3
        @case.timings.first.estimated_conclusion_slow = Date.today + (params[:case]['timings_attributes']['0']['estimated_conclusion_slow']).to_i.month
      end
    end
    #If fee type is fixed fee... medium estimate == contract amount and high/low estimate = medium estimate
    if params[:case]['fees_attributes']['0']['fee_type'] == "Fixed Fee"
      @case.fees.first.high_estimate = params[:case]['fees_attributes']['0']['medium_estimate']
      @case.fees.first.low_estimate = params[:case]['fees_attributes']['0']['medium_estimate']
    end
    @case.fees.last.referral_estimates
    if @case.save
      Closeout.open_case(@case)
      if @case.fees.first.fee_type == 'Fixed Fee'
        FixedFee.initial_fixed_fee(@case)
      end
      add_staff_to_staff_case
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

  def new_closed_case
    new_case_material
    @case.closeouts.build
  end

  def create_closed_case
    new_create_case_objects
    if @case.save
      #Mark case.open == false
      Closeout.close_case(@case)
      #add new_originations to originations db unless user did not input a new origination source
      unless params[:case][:originations_attributes]["0"][:new_referral_source].empty?
        source_description = params[:case][:originations_attributes]["0"][:source_description] unless nil
        @new_origination = Origination.new(referral_source: params[:case][:originations_attributes]["0"][:new_referral_source],
                                          case_id: @case.id,
                                          source_description: source_description)
        @new_origination.save
      end
      add_staff_to_staff_case
      flash[:success] = "Case Added Successfully"
      redirect_to client_case_path(@case.client_id,@case)
    else
      render 'new_closed_case'
    end
  end

  def index
    @client = current_user.clients.find(params[:client_id])
    @cases = @client.cases.load
  end

  def new
    @case = Case.new
    @client = Client.find(params[:client_id])
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
    @case = Case.find(params[:id])
    params[:case][:court] = params[:case][:new_court] unless params[:case][:new_court].empty?
    #add a new judge unless user selects from dropdown list
    params[:case][:judge] = params[:case][:new_judge] unless params[:case][:new_judge].empty?
    #add a new attorney unless user selects from dropdown list
    params[:case][:opposing_attorney] = params[:case][:new_opposing_attorney] unless params[:case][:new_opposing_attorney].empty?
    if @case.update_attributes(case_params)
      flash[:success] = "Updated case matter information"
      redirect_to client_case_path(@client,@case)
    else
      render 'edit'
    end
  end

  def edit
    @client = Client.find(params[:client_id])
    @case = Case.find(params[:id])
  end

  def show
    @case = Case.find(params[:id])
    @lead_attorney = Case.lead_attorney(@case)
    if @lead_attorney.blank?
      @lead_attorney = "Select a Responsible Attorney in Staff"
    end
  end

  def destroy
  end

  def user_cases
    @cases = current_user.cases.load
  end

  private

    def case_params
      params.require(:case).permit(:client, :new_court, :court, :new_type_of_matter, :new_practice_group,
                                              :name, :open, :client_id, :case_number, :new_opposing_attorney,
                                              :opposing_attorney, :new_judge, :judge, :related_cases, :description, :user_id,
                                              :practicegroup_id, :primary_email,
                                    :fees_attributes => [:fee_type, :high_estimate, :medium_estimate,
                                                          :low_estimate, :payment_likelihood, :retainer,
                                                          :cost_estimate, :referral_percentage],
                                    :staffs_attributes => [:name, :position, :hours_expected, :staffing_id,
                                                           :hours_actual],
                                    :originations_attributes => [:new_referral_source, :referral_source, :source_description],
                                    :checks_attributes => [:conflict_check, :conflict_date, :referring_engagement_letter,
                                                            :referring_engagement_letter_date, :client_engagement_letter,
                                                            :client_engagement_letter_date],
                                    :timings_attributes => [:date_opened, :estimated_conclusion_fast,
                                                            :estimated_conclusion_expected,
                                                            :estimated_conclusion_slow, :case_filed],
                                    :closeouts_attributes => [:total_recovery, :total_gross_fee_received,
                                                              :total_out_of_pocket_expenses, :referring_fees_paid,
                                                              :total_fee_received, :date_fee_received, :fee_type],
                                    :matters_attributes => [:case_type_id],
                                    :related_cases_attributes => [:related_case_id])

    end

    def new_case_material
      @case = Case.new
      @case.matters.build
      @case.related_cases.build
      @case.staffs.build
      @case.originations.build
    end

    def new_create_case_objects
      @case = Case.new(case_params)
      @case.court = params[:case][:new_court] unless params[:case][:new_court].empty?
      @case.judge = params[:case][:new_judge] unless params[:case][:new_judge].empty?
      @case.opposing_attorney = params[:case][:new_opposing_attorney] unless params[:case][:new_opposing_attorney].empty?
      unless params[:case][:new_practice_group].empty?
        @new_pg = Practicegroup.create!(group_name: params[:case][:new_practice_group], lawfirm_id: current_user.lawfirm.id) unless current_user.lawfirm.practicegroups.collect(&:group_name).include?(params[:case][:new_practice_group])
        @case.practicegroup_id = Practicegroup.find_by(group_name: params[:case][:new_practice_group]).id
      end
      unless params[:case][:originations_attributes]["0"][:new_referral_source].empty?
        @case.originations.first.referral_source = params[:case][:originations_attributes]["0"][:new_referral_source]
      end
      @case.primary_email = current_user.email
    end

    def add_staff_to_staff_case
      unless params[:case][:staffs_attributes] == nil
        @staff_list = params[:case][:staffs_attributes].values
        case_id = @case.id
        StaffCase.add_to_staff_master_list(@staff_list,case_id)
      end
    end



end
