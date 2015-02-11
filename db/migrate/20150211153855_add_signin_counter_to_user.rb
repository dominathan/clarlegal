class AddSigninCounterToUser < ActiveRecord::Migration
  def change
    add_column :users, :signin_counter, :integer, default: 0
  end
end
