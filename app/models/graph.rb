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


end
