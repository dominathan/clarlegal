class AddLawfirmReferenceAndRateToOverhead < ActiveRecord::Migration
  def change
    add_reference :overheads, :lawfirm, index: true
    add_column :overheads, :rate_per_hour, :float
  end
end
