class CasesController < ApplicationController
  before_action :signed_in_user
  before_action :belongs_to_firm

  #currently open cases
  def new_case
    @case = Case.new
    @case.fees.build
    @case.staffs.build
    @case.timings.build
    @case.originations.build
    @case.checks.build
  end

  #Create open case to DB...Read comments for information about the purpose of individual lines
  def create_case
    @case = Case.new(case_params)
    #add a newcourt unless user selects from dropdown list
    @case.court = params[:case][:new_court] unless params[:case][:new_court].empty?
    #add a new judge unless user selects from dropdown list
    @case.judge = params[:case][:new_judge] unless params[:case][:new_judge].empty?
    #add a new attorney unless user selects from dropdown list
    @case.opposing_attorney = params[:case][:new_opposing_attorney] unless params[:case][:new_opposing_attorney].empty?
    #add new type_of_matter to user lawfirm CaseType unless empty
    unless params[:case][:new_type_of_matter].empty?
      @case.type_of_matter = params[:case][:new_type_of_matter]
      @new_matref = CaseType.create!(mat_ref: params[:case][:new_type_of_matter], lawfirm_id: current_user.lawfirm.id)
    end
    #add new practice group to user lawfirm practicegroups unless :new_practice_group is empty
    unless params[:case][:new_practice_group].empty?
      @case.practice_group = params[:case][:new_practice_group]
      @new_pg = Practicegroup.create!(group_name: params[:case][:new_practice_group], lawfirm_id: current_user.lawfirm.id)
    end
    #add new referral source to database if empty
    unless params[:case][:originations_attributes]["0"][:new_referral_source].empty?
      @case.originations.first.referral_source = params[:case][:originations_attributes]["0"][:new_referral_source]
    end
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
    #if fee type is fixed fee... medium estimate == contract amount and high/low estimate = medium estimate
    if params[:case]['fees_attributes']['0']['fee_type'] == "Fixed Fee"
      @case.fees.first.high_estimate = params[:case]['fees_attributes']['0']['medium_estimate']
      @case.fees.first.low_estimate = params[:case]['fees_attributes']['0']['medium_estimate']
    end
    if @case.save
      #set case to open
      Closeout.open_case(@case)
      #create Fixed Fee DB entry for montly conversion if fee_type == fixed fee
      if @case.fees.first.fee_type == 'Fixed Fee'
        FixedFee.initial_fixed_fee(@case)
      end
      #add all staff to StaffCase DB as Master List unless no staff
      unless params[:case][:staffs_attributes] == nil
        @staff_list = params[:case][:staffs_attributes].values
        case_id = @case.id
        StaffCase.add_to_staff_master_list(@staff_list,case_id)
      end
      #add new_originations to originations db unless user did not input a new origination source
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

  #For cases that law firm has already received judgement, use new_closed_case
  def new_closed_case
    @case = Case.new
    @case.closeouts.build
    @case.originations.build
    @case.staffs.build
  end
  #Logs closed cases to DB
  def create_closed_case
    @case = Case.new(case_params)
    #add a newcourt unless user selects from dropdown list
    @case.court = params[:case][:new_court] unless params[:case][:new_court].empty?
    #add a new judge unless user selects from dropdown list
    @case.judge = params[:case][:new_judge] unless params[:case][:new_judge].empty?
    #add a new attorney unless user selects from dropdown list
    @case.opposing_attorney = params[:case][:new_opposing_attorney] unless params[:case][:new_opposing_attorney].empty?
    #add new type_of_matter to user lawfirm CaseType unless empty
    unless params[:case][:new_type_of_matter].empty?
      @case.type_of_matter = params[:case][:new_type_of_matter]
      @new_matref = CaseType.create!(mat_ref: params[:case][:new_type_of_matter], lawfirm_id: current_user.lawfirm.id)
    end
    #add new practice group to user lawfirm practicegroups unless :new_practice_group is empty
    unless params[:case][:new_practice_group].empty?
      @case.practice_group = params[:case][:new_practice_group]
      @new_pg = Practicegroup.create!(group_name: params[:case][:new_practice_group], lawfirm_id: current_user.lawfirm.id) unless current_user.lawfirm.practicegroups.collect(&:group_name).include?(params[:case][:new_practice_group])
    end
    #add new referral source to database if empty
    unless params[:case][:originations_attributes]["0"][:new_referral_source].empty?
      @case.originations.first.referral_source = params[:case][:originations_attributes]["0"][:new_referral_source]
    end
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
      flash[:success] = "Case Added Successfully"
      redirect_to client_case_path(@case.client_id,@case)
    else
      render 'new_closed_case'
    end
  end

  def index
    @client = current_user.clients.find(params[:client_id])
    if @client.cases.exists?
      @case = @client.cases.paginate(:page => params[:page], :per_page => 10 )
    end
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
      case_list = Case.search(params[:search], with: { client_id: client_id_list}, page: params[:page], per_page: 1000).collect {|c|c.id}
      @case = Case.where(id: case_list).paginate(:page  => params[:page], :per_page => 10 )
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
                                                              :total_fee_received, :date_fee_received])
    end



end
