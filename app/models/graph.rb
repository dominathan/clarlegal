class Graph < ActiveRecord::Base

  #open cases by lawfirm
  def self.open_cases(user)
    user.lawfirm.cases.where(open: true)
  end

  #closed cases by lawfirm
  def self.closed_cases(user)
    user.lawfirm.cases.where(open: false)
  end

  #practice_group names by lawfirm
  def self.user_practice_groups(user)
    user.lawfirm.practicegroups.collect { |n| n.group_name }
  end

  #start year should be five years prior to the most recent collection fee_received
  def self.closeout_years
    all_dates = Closeout.all.order(:date_fee_received).collect { |cl| cl.date_fee_received }
    start_year = all_dates.sort.last.year-4
    [start_year, start_year+1,start_year+2,start_year+3,start_year+4]
  end

  def self.closeout_amounts(case_name,amount_type)
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    category_years = closeout_years
    if case_name.closeouts.last.date_fee_received
      date_received = case_name.closeouts.last.date_fee_received.year
    end
    if closeout_amount_type(case_name,amount_type)
      if date_received == category_years[0]
        rev_est_year1 += Graph.closeout_amount_type(case_name,amount_type)
      elsif date_received == category_years[1]
        rev_est_year2 += Graph.closeout_amount_type(case_name,amount_type)
      elsif date_received == category_years[2]
        rev_est_year3 += Graph.closeout_amount_type(case_name,amount_type)
      elsif date_received == category_years[3]
        rev_est_year4 += Graph.closeout_amount_type(case_name,amount_type)
      elsif date_received == category_years[4]
        rev_est_year5_plus += Graph.closeout_amount_type(case_name,amount_type)
      end
    end
  end

  def self.closeout_amount_type(case_name,amount_type)
    if amount_type == 'total_recovery'
      case_name.closeouts.last.total_recovery
    elsif amount_type == 'total_gross_fee_received'
      case_name.closeouts.last.total_gross_fee_received
    elsif amount_type == "total_out_of_pocket_expenses"
      case_name.closeouts.last.total_out_of_pocket_expenses
    elsif amount_type == "referring_fees_paid"
      case_name.closeouts.last.referring_fees_paid
    elsif amount_type == "total_fee_received"
      case_name.closeouts.last.total_fee_received
    end
  end


end
