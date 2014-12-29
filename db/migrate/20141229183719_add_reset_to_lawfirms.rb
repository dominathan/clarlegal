class AddResetToLawfirms < ActiveRecord::Migration
  def change
    add_column :lawfirms, :reset_digest, :string
    add_column :lawfirms, :reset_sent_at, :datetime
  end
end
