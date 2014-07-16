class StaffCase < ActiveRecord::Base
  belongs_to :staffing
  belongs_to :case
end
