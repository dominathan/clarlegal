class Matter < ActiveRecord::Base
  belongs_to :case
  belongs_to :case_type
end
