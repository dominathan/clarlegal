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

end
