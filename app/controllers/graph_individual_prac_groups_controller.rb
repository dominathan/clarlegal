class GraphIndividualPracGroupsController < ApplicationController


  def expected_individual_pg_rev(prac_group)
    open_cases = Graph.open_cases(current_user)
    current_date = DateTime.now
    category_years = set_yearly_category_variables
    @lawfirm_pg_rev = []
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = current_date.to_time.advance(:months => (ca.timing.order(:created_at).last.estimated_conclusion_expected)) : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += ca.fee.order(:created_at).last.medium_estimate
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += ca.fee.order(:created_at).last.medium_estimate
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += ca.fee.order(:created_at).last.medium_estimate
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += ca.fee.order(:created_at).last.medium_estimate
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += ca.fee.order(:created_at).last.medium_estimate
        end
      else
        next
      end
      @five_year_estimate = rev_est
    end
    @lawfirm_pg_rev << @five_year_estimate
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
