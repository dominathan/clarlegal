class Graph < ActiveRecord::Base

  def self.practice_group_pie(user)
    #Step 1. Get list of all cases that are either open or closed.
            # Create arrays to hold practicegroup totals
    open_cases(user)
    closed_cases(user)
    @open_cases_by_pg =[]
    @closed_cases_by_pg =[]
    #Step 2. Get list of practice groups in current user lawfirm
    @lawfirm_pgs = user.lawfirm.practicegroups.collect { |n| n.group_name }
    @pg_count = @lawfirm_pgs.length
    #Step 3.  For every practice group in a lawfirm, total the number of cases that belong
              # to that practice group and is open, as well as closed
    0.upto(@pg_count-1) do |n|
      @open_cases_by_pg.push(@open_case_total.where(practice_group: @lawfirm_pgs[n]).count)
      @closed_cases_by_pg.push(@closed_case_total.where(practice_group: @lawfirm_pgs[n]).count)
    end
    #Step 4. Combine the lawfirm practice group with the count..e.g.[['Med Mal', 5]]
    @final_case_closed = @lawfirm_pgs.zip(@closed_cases_by_pg)
    @final_case_open = @lawfirm_pgs.zip(@open_cases_by_pg)
  end

  def self.open_cases(user)
    @open_case_total = user.lawfirm.cases.where(open: true)
  end

  def self.closed_cases(user)
    @closed_case_total = user.lawfirm.cases.where(open: false)
  end



end
