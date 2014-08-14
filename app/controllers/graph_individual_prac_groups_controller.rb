class GraphIndividualPracGroupsController < ApplicationController


  def expected_individual_pg_rev
    prac_group = Practicegroup.find(params[:id]).group_name
    open_cases = Graph.open_cases(current_user)
    current_date = DateTime.now
    @category_years = set_yearly_category_variables
    @lawfirm_pg_rev = []
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = current_date.to_time.advance(:months => (Graph.time_to_collection(ca,'expected'))) : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"low")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev << rev_est
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = current_date.to_time.advance(:months => (Graph.time_to_collection(ca,'expected'))) : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"medium")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev << rev_est
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = current_date.to_time.advance(:months => (Graph.time_to_collection(ca,'expected'))) : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"high")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev << rev_est
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = current_date.to_time.advance(:months => (Graph.time_to_collection(ca,'expected'))) : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"cost")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev << rev_est
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = current_date.to_time.advance(:months => (Graph.time_to_collection(ca,'expected'))) : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"referral")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev << rev_est
  end

  def set_yearly_rev_array
    [rev_est_year1 = 0, rev_est_year2 = 0, rev_est_year3 = 0, rev_est_year4 = 0, rev_est_year5_plus = 0]
  end

  def set_yearly_category_variables
    current_date = DateTime.now
    [current_date.year, current_date.year+1, current_date.year+2,
                        current_date.year+3, current_date.year+4]
  end


end
