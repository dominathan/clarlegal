class AddAdminToLawfirm < ActiveRecord::Migration
  def change
    add_reference :lawfirms, :user, index: true
  end
end
