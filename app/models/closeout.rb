class Closeout < ActiveRecord::Base
  belongs_to :case

  validates :case_id, presence: true

  def self.close_case(case_name)
    case_name.open = 0
    case_name.save
  end

  def self.open_case(case_name)
    case_name.open = 1
    case_name.save
  end


end
