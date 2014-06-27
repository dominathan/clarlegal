class AddLawfirmRefToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :lawfirm, index: true
  end
end
